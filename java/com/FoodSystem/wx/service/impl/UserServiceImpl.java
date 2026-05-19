package com.FoodSystem.wx.service.impl;

import com.FoodSystem.wx.entity.User;
import com.FoodSystem.wx.mapper.UserMapper;
import com.FoodSystem.wx.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String name, String phone) {
        return userMapper.getByNameAndPhone(name, phone);
    }
}


