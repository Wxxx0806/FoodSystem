package com.FoodSystem.wx.service.impl;

import com.FoodSystem.wx.entity.Dish;
import com.FoodSystem.wx.entity.result.PageResult;
import com.FoodSystem.wx.mapper.DishMapper;
import com.FoodSystem.wx.service.DishService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DishServiceImpl implements DishService {

    @Autowired
    private DishMapper dishMapper;

    /**
     * 插入菜品
     */
    @Override
    public void add(Dish dish) {
        dishMapper.insert(dish);
    }

    /**
     * 更新菜品
     */
    @Override
    public void update(Dish dish) {
        dishMapper.update(dish);
    }

    /**
     * 删除菜品
     */
    @Override
    public void delete(Long id) {
        dishMapper.deleteById(id);
    }

    /**
     * 根据ID查询菜品
     */
    @Override
    public Dish getById(Long id) {
        return dishMapper.getById(id);
    }

    /**
     * 查询所有菜品
     */
    @Override
    public List<Dish> getAll() {
        return dishMapper.getAll();
    }


    /**
     * 分页查询菜品
     */
    @Override
    public PageResult pageQuery(int page, int pageSize, String name) {
        // 计算起始索引
        int offset = (page - 1) * pageSize;

        // 查询数据列表
        List<Dish> dishes = dishMapper.pageQuery(name, offset, pageSize);

        // 计算总记录数
        int total = dishMapper.countByName(name);

        // 创建分页结果对象
        PageResult pageResult = new PageResult();
        pageResult.setList(dishes);
        pageResult.setTotal(total);
        pageResult.setPageNum(page);
        pageResult.setPageSize(pageSize);
        pageResult.setPages((int) Math.ceil((double) total / pageSize));

        return pageResult;
    }


}
