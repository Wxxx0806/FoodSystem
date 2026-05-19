package com.FoodSystem.wx.service;



import com.FoodSystem.wx.dto.CreateOrderRequest;
import com.FoodSystem.wx.entity.OrderDetail;
import com.FoodSystem.wx.entity.Orders;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface OrdersService {
    /**
     * 下单
     * @param userId 用户ID
     * @param dishMap 菜品ID -> 数量
     * @return 订单ID
     */
    List<OrderDetail> createOrder(Long userId, Map<Long, Integer> dishMap);

    /**
     * 订单支付成功回调
     * @param orderId 订单ID
     */
    void paySuccess(Long orderId);

    /**
     * 取消订单
     * @param orderId 订单ID
     * @param reason 取消原因
     */
    void cancelOrder(Long orderId, String reason);

    /**
     * 查询用户订单列表
     */
    List<Orders> listByUser(Long userId);

    /**
     * 查询所有订单列表
     */
    List<Orders> listAll();

    /**
     * 查询订单详情
     */
    List<OrderDetail> getOrderDetail(Long orderId);

    /**
     * 获取订单趋势（按日期统计订单数量和营业额）
     * @param days 最近多少天
     * @return 统计数据列表
     */
    List<Map<String, Object>> getOrderTrend(Integer days);

    /**
     * 获取订单状态分布
     * @return 状态统计数据列表
     */
    List<Map<String, Object>> getOrderStatusDistribution();

    /**
     * 获取订单时间分布（按小时）
     * @return 小时统计数据列表
     */
    List<Map<String, Object>> getOrderHourDistribution();
}
