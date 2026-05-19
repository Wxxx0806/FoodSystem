package com.FoodSystem.wx.service.impl;


import com.FoodSystem.wx.entity.Dish;
import com.FoodSystem.wx.entity.OrderDetail;
import com.FoodSystem.wx.entity.Orders;
import com.FoodSystem.wx.mapper.DishMapper;
import com.FoodSystem.wx.mapper.OrderDetailMapper;
import com.FoodSystem.wx.mapper.OrdersMapper;
import com.FoodSystem.wx.service.OrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.data.redis.core.ValueOperations;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import java.math.BigDecimal;
import java.time.ZoneId;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Service
public class OrderServiceImpl implements OrdersService {

    @Autowired
    private OrdersMapper ordersMapper;

    @Autowired
    private OrderDetailMapper orderDetailMapper;

    @Autowired
    private DishMapper dishMapper;

    @Autowired
    private StringRedisTemplate redisTemplate;

    private static final String LOCK_PREFIX = "order:dish:lock:";

    /**
     * 下单流程：
     * 1. 预扣库存
     * 2. 创建订单
     * 3. 创建订单明细
     */

    /**
     * 创建订单
     *
     * @param userId  用户ID
     * @param dishMap 菜品ID -> 数量
     * @return
     */

//① Redis 分布式锁
//② 预扣库存（updateStockForPreDeduct）
//③ 创建订单（orders 表）
//④ 创建订单明细（order_detail 表）
    @Override
    @Transactional
    public List<OrderDetail> createOrder(Long userId, Map<Long, Integer> dishMap) {

        // 1. 预扣库存（加分布式锁）
        for (Map.Entry<Long, Integer> entry : dishMap.entrySet()) {
            Long dishId = entry.getKey();
            Integer qty = entry.getValue();

            String lockKey = LOCK_PREFIX + dishId;
            // 获取锁
            ValueOperations<String, String> ops = redisTemplate.opsForValue();

            // 简单加锁，5秒自动释放
            Boolean success = ops.setIfAbsent(lockKey, "1", 5, TimeUnit.SECONDS);
            if (Boolean.FALSE.equals(success)) {
                throw new RuntimeException("库存锁定失败，请稍后再试");
            }

            int rows = dishMapper.updateStockForPreDeduct(dishId, qty);
            if (rows <= 0) {
                // 回滚已预扣库存
                for (Map.Entry<Long, Integer> rollbackEntry : dishMap.entrySet()) {
                    dishMapper.rollbackPreDeduct(rollbackEntry.getKey(), rollbackEntry.getValue());
                }
                redisTemplate.delete(lockKey);
                throw new RuntimeException("库存不足，订单创建失败");
            }

            // 释放锁
            redisTemplate.delete(lockKey);
        }

        // 2. 创建订单
        Orders order = new Orders();
        order.setUserId(userId);
        order.setNumber(UUID.randomUUID().toString());
        order.setStatus(1); // 待支付
        order.setPayStatus(0); // 未支付
//        order.setOrderTime(new Date());
        order.setOrderTime(new Date().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime());
        order.setPayMethod(1);

        // 计算总金额
        double total = 0;
        for (Map.Entry<Long, Integer> entry : dishMap.entrySet()) {
            Dish dish = dishMapper.getById(entry.getKey());
            total += dish.getPrice().doubleValue() * entry.getValue();
        }
        order.setAmount(BigDecimal.valueOf(total));

        ordersMapper.insertOrder(order);

        // 3. 创建订单明细
        List<OrderDetail> detailList = new ArrayList<>();
        for (Map.Entry<Long, Integer> entry : dishMap.entrySet()) {
            Dish dish = dishMapper.getById(entry.getKey());
            OrderDetail detail = new OrderDetail();
            detail.setOrderId(order.getId());
            detail.setDishId(dish.getId());
            detail.setName(dish.getName());
            detail.setNumber(entry.getValue());
            detail.setAmount(BigDecimal.valueOf(dish.getPrice().doubleValue()));
            detail.setImage(dish.getImage());
            detail.setPrice(dish.getPrice());
            detail.setSubtotal(BigDecimal.valueOf(dish.getPrice().doubleValue() * entry.getValue()));
            detailList.add(detail);
        }

        orderDetailMapper.batchInsert(detailList);

        return detailList;
    }

    /**
     * 支付成功
     *
     * @param orderId 订单ID
     */

    @Override
    @Transactional
    public void paySuccess(Long orderId) {
        Orders order = ordersMapper.getById(orderId);
        if (order == null || order.getPayStatus() == 1) {
            throw new RuntimeException("订单不存在或已支付");
        }

        // 1. 扣除冻结库存
        List<OrderDetail> details = orderDetailMapper.listByOrderId(orderId);
        for (OrderDetail d : details) {
            dishMapper.finalizeDeduct(d.getDishId(), d.getNumber());
        }

        // 2. 更新支付状态和订单状态
        ordersMapper.updatePayStatus(orderId, 1);
        ordersMapper.updateStatus(orderId, 2); // 已支付
        ordersMapper.updateCheckoutTime(orderId, new Date().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDateTime().toString());
    }

    /**
     * 取消订单
     */
    @Override
    @Transactional
    public void cancelOrder(Long orderId, String reason) {
        Orders order = ordersMapper.getById(orderId);
        if (order == null || order.getStatus() != 1) {
            throw new RuntimeException("订单不存在或无法取消");
        }

        // 回滚库存
        List<OrderDetail> details = orderDetailMapper.listByOrderId(orderId);
        for (OrderDetail d : details) {
            dishMapper.rollbackPreDeduct(d.getDishId(), d.getNumber());
        }

        // 更新订单状态
        ordersMapper.cancelOrder(orderId, reason);
    }

    /**
     * 查询订单列表
     *
     * @param userId
     * @return
     */
    @Override
    public List<Orders> listByUser(Long userId) {
        return ordersMapper.listByUser(userId);
    }

    /**
     * 查询所有订单
     *
     * @return
     */
    @Override
    public List<Orders> listAll() {
        return ordersMapper.listAll();
    }

    /**
     * 查询订单详情
     *
     * @param orderId
     * @return
     */
    @Override
    public List<OrderDetail> getOrderDetail(Long orderId) {
        return orderDetailMapper.listByOrderId(orderId);
    }

    /**
     * 获取订单趋势（按日期统计订单数量和营业额）
     *
     * @param days 最近多少天，默认7天
     * @return 统计数据列表
     */
    @Override
    public List<Map<String, Object>> getOrderTrend(Integer days) {
        if (days == null || days <= 0) {
            days = 7; // 默认最近7天
        }
        List<Map<String, Object>> result = ordersMapper.getOrderTrend(days);
        // 确保 totalAmount 转换为 Double 类型（前端需要数字类型）
        for (Map<String, Object> item : result) {
            if (item.containsKey("totalAmount")) {
                Object amount = item.get("totalAmount");
                if (amount instanceof BigDecimal) {
                    item.put("totalAmount", ((BigDecimal) amount).doubleValue());
                } else if (amount != null) {
                    item.put("totalAmount", Double.parseDouble(amount.toString()));
                } else {
                    item.put("totalAmount", 0.0);
                }
            }
            // 确保 orderCount 是 Integer
            if (item.containsKey("orderCount")) {
                Object count = item.get("orderCount");
                if (count instanceof Long) {
                    item.put("orderCount", ((Long) count).intValue());
                } else if (count != null) {
                    item.put("orderCount", Integer.parseInt(count.toString()));
                } else {
                    item.put("orderCount", 0);
                }
            }
        }
        return result;
    }

    /**
     * 获取订单状态分布
     *
     * @return 状态统计数据列表
     */
    @Override
    public List<Map<String, Object>> getOrderStatusDistribution() {
        List<Map<String, Object>> result = ordersMapper.getOrderStatusDistribution();
        // 确保 count 是 Integer 类型
        for (Map<String, Object> item : result) {
            if (item.containsKey("count")) {
                Object count = item.get("count");
                if (count instanceof Long) {
                    item.put("count", ((Long) count).intValue());
                } else if (count != null) {
                    item.put("count", Integer.parseInt(count.toString()));
                } else {
                    item.put("count", 0);
                }
            }
            // 确保 status 是 Integer 类型
            if (item.containsKey("status")) {
                Object status = item.get("status");
                if (status instanceof Long) {
                    item.put("status", ((Long) status).intValue());
                } else if (status != null) {
                    item.put("status", Integer.parseInt(status.toString()));
                }
            }
        }
        return result;
    }

    /**
     * 获取订单时间分布（按小时）
     *
     * @return 小时统计数据列表
     */
    @Override
    public List<Map<String, Object>> getOrderHourDistribution() {
        List<Map<String, Object>> result = ordersMapper.getOrderHourDistribution();
        // 确保 hour 和 count 都是 Integer 类型
        for (Map<String, Object> item : result) {
            if (item.containsKey("hour")) {
                Object hour = item.get("hour");
                if (hour instanceof Long) {
                    item.put("hour", ((Long) hour).intValue());
                } else if (hour != null) {
                    item.put("hour", Integer.parseInt(hour.toString()));
                } else {
                    item.put("hour", 0);
                }
            }
            if (item.containsKey("count")) {
                Object count = item.get("count");
                if (count instanceof Long) {
                    item.put("count", ((Long) count).intValue());
                } else if (count != null) {
                    item.put("count", Integer.parseInt(count.toString()));
                } else {
                    item.put("count", 0);
                }
            }
        }
        return result;
    }
}
