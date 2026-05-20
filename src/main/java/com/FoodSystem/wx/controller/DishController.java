package com.FoodSystem.wx.controller;

import com.FoodSystem.wx.entity.Dish;
import com.FoodSystem.wx.entity.result.PageResult;
import com.FoodSystem.wx.entity.result.Result;
import com.FoodSystem.wx.service.DishService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/dish")
public class DishController {

    @Autowired
    private DishService dishService;


    /**
     * 查询所有菜品
     */
    @GetMapping("/all")
    public Result<List<Dish>> getAll() {
        try {
            List<Dish> dishes = dishService.getAll();
            return Result.success(dishes);
        } catch (Exception e) {
            return Result.error("查询菜品失败：" + e.getMessage());
        }
    }


    /**
     * 根据 ID 查询菜品
     */
    @GetMapping("/{id}")
    public Result getById(@PathVariable Long id) {
        Dish dish = dishService.getById(id);
        if (dish != null) {
            return Result.success("操作成功", dish);
        }
        return Result.error("未找到对应的菜品");
    }

    /**
     * 删除菜品
     */
    @DeleteMapping("/{id}")
    public Result deleteById(@PathVariable Long id) {
        try {
            dishService.delete(id);
            return Result.success("操作成功");
        } catch (Exception e) {
            return Result.error("删除菜品失败：" + e.getMessage());
        }
    }

    /**
     * 菜品分页查询
     */
    @GetMapping("/page")
    public Result<PageResult> pageQuery(
            @RequestParam int page,
            @RequestParam int pageSize,
            @RequestParam(required = false) String name) {

        PageResult pageResult = dishService.pageQuery(page, pageSize, name);
        return Result.success("操作成功", pageResult);
    }

}