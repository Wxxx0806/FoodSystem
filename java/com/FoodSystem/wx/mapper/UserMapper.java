package com.FoodSystem.wx.mapper;

import com.FoodSystem.wx.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {

    /**
     * 根据姓名和手机号查询用户
     *
     * @param name  姓名
     * @param phone 手机号
     * @return User
     */
    User getByNameAndPhone(@Param("name") String name, @Param("phone") String phone);
}


