package com.FoodSystem.wx.service;

import com.FoodSystem.wx.entity.User;

public interface UserService {

    /**
     * 用户登录：根据姓名和手机号查询用户
     *
     * @param name  姓名
     * @param phone 手机号
     * @return User，查询不到返回 null
     */
    User login(String name, String phone);
}


