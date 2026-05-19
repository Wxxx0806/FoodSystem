package com.FoodSystem.wx.mapper;


import com.FoodSystem.wx.entity.Orders;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface OrdersMapper {

    // 创建订单
    int insertOrder(Orders orders);

    // 根据ID查询订单
    Orders getById(@Param("id") Long id);

    // 根据订单号查询订单
    Orders getByNumber(@Param("number") String number);

    // 查询用户订单列表
    List<Orders> listByUser(@Param("userId") Long userId);

    // 查询所有订单列表
    List<Orders> listAll();

    // 更新订单状态
    int updateStatus(
            @Param("id") Long id,
            @Param("status") Integer status
    );

    // 更新支付状态（0未支付，1已支付）
    int updatePayStatus(
            @Param("id") Long id,
            @Param("payStatus") Integer payStatus
    );

    // 更新支付时间
    int updateCheckoutTime(
            @Param("id") Long id,
            @Param("checkoutTime") String checkoutTime
    );

    // 用户取消订单
    int cancelOrder(
            @Param("id") Long id,
            @Param("cancelReason") String cancelReason
    );

    // 分页查询订单（后台）
    List<Orders> pageQuery(
            @Param("status") Integer status,
            @Param("userId") Long userId,
            @Param("start") Integer start,
            @Param("pageSize") Integer pageSize
    );

    // 按日期统计订单数量和营业额（最近7天）
    List<Map<String, Object>> getOrderTrend(@Param("days") Integer days);

    // 按状态统计订单数量
    List<Map<String, Object>> getOrderStatusDistribution();

    // 按小时统计订单数量（24小时分布）
    List<Map<String, Object>> getOrderHourDistribution();

}
