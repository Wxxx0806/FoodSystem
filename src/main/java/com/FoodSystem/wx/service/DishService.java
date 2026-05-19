package com.FoodSystem.wx.service;


import com.FoodSystem.wx.entity.Dish;
import com.FoodSystem.wx.entity.result.PageResult;

import java.util.List;

public interface DishService {
    void add(Dish dish);

    void update(Dish dish);

    void delete(Long id);

    Dish getById(Long id);

    List<Dish> getAll();

    PageResult pageQuery(int page, int pageSize, String name);

}
