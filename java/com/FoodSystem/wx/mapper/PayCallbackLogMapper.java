package com.FoodSystem.wx.mapper;


import com.FoodSystem.wx.entity.PayCallbackLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface PayCallbackLogMapper {

    /**
     * 保存回调日志
     *
     * @param log
     * @return
     */
    int insertLog(PayCallbackLog log);

    /**
     * 根据订单号查询
     *
     * @param orderNumber
     * @return
     */
    List<PayCallbackLog> listByOrderNumber(@Param("orderNumber") String orderNumber);


    /**
     * 查询最新记录
     *
     * @param orderNumber
     * @return
     */
    PayCallbackLog latestLog(@Param("orderNumber") String orderNumber);
}
