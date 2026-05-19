package com.FoodSystem.wx.controller;


import com.FoodSystem.wx.entity.OrderDetail;
import com.FoodSystem.wx.entity.Orders;
import com.FoodSystem.wx.entity.result.Result;
import com.FoodSystem.wx.service.OrdersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/orders")
public class OrdersController {

    @Autowired
    private OrdersService ordersService;

    // 下单接口
    @PostMapping("/create")
    public Result<Map<Long, Integer>> create(@RequestParam Long userId,
                                             @RequestBody Map<Long, Integer> dishMap) {
        ordersService.createOrder(userId, dishMap);
        return Result.success("下单成功", dishMap);
    }

    // 支付回调接口
    @PostMapping("/paySuccess")
    public Result paySuccess(@RequestParam Long orderId) {
        ordersService.paySuccess(orderId);
        return Result.success("支付成功", orderId);
    }

    // 取消订单
    @PostMapping("/cancel")
    public Result<Map<Long, String>> cancel(@RequestParam Long orderId,
                                            @RequestParam String reason) {
        Map<Long, String> data = new HashMap<>();
        data.put(orderId, reason);
        ordersService.cancelOrder(orderId, reason);

        return Result.success("取消成功", data);
    }

    // 查询订单列表（userId 可选，缺省返回全部）
    @GetMapping("/list")
    public Result<List<Orders>> list(@RequestParam(required = false) Long userId) {
        List<Orders> orders;
        if (userId != null) {
            orders = ordersService.listByUser(userId);
        } else {
            orders = ordersService.listAll();
        }
        return Result.success("查询成功", orders );
    }

    // 查询订单详情
    @GetMapping("/detail")
    public Result<List<OrderDetail>> detail(@RequestParam Long orderId) {
        ordersService.getOrderDetail(orderId);
        return Result.success("查询成功", ordersService.getOrderDetail(orderId));
    }

    // 获取订单趋势统计（按日期）
    @GetMapping("/statistics/trend")
    public Result<List<Map<String, Object>>> getOrderTrend(@RequestParam(required = false, defaultValue = "7") Integer days) {
        List<Map<String, Object>> data = ordersService.getOrderTrend(days);
        return Result.success("查询成功", data);
    }

    // 获取订单状态分布
    @GetMapping("/statistics/status")
    public Result<List<Map<String, Object>>> getOrderStatusDistribution() {
        List<Map<String, Object>> data = ordersService.getOrderStatusDistribution();
        return Result.success("查询成功", data);
    }

    // 获取订单时间分布（按小时）
    @GetMapping("/statistics/hour")
    public Result<List<Map<String, Object>>> getOrderHourDistribution() {
        List<Map<String, Object>> data = ordersService.getOrderHourDistribution();
        return Result.success("查询成功", data);
    }
}
