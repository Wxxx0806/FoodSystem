package com.FoodSystem.wx.mapper;



import com.FoodSystem.wx.entity.OrderDetail;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrderDetailMapper {

    // 批量插入
    int batchInsert(@Param("list") List<OrderDetail> list);

    // 根据订单ID查询
    List<OrderDetail> listByOrderId(@Param("orderId") Long orderId);

    // 删除明细
    int deleteByOrderId(@Param("orderId") Long orderId);

    // 查询订单总金额
    Double totalAmount(@Param("orderId") Long orderId);
}

