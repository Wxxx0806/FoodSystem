package com.FoodSystem.wx.mapper;

import com.FoodSystem.wx.entity.Dish;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface DishMapper {
    //插入菜品
    void insert(Dish dish);

    //更新菜品
    void update(Dish dish);

    //根据ID删除菜品
    @Delete("delete from `food-system`.dish where id=#{id}")
    void deleteById(@Param("id") Long id);

    //根据ID查询菜品
    Dish getById(Long id);

    //查询菜品
    @Select("select * from `food-system`.dish")
    List<Dish> getAll();

    //更新菜品状态
    void updateStatus(@Param("status") Integer status, @Param("id") Long id);

    //分页查询
    List<Dish> pageQuery(@Param("name") String name, @Param("offset") Integer offset, @Param("pageSize") Integer pageSize);

    //统计总数
    Integer countByName(@Param("name") String name);

    // ============= 新增：库存操作 =============

    // 预扣库存（库存 -= qty，但标记为锁定库存）
    int updateStockForPreDeduct(@Param("id") Long id, @Param("qty") Integer qty);

    // 回滚预扣库存（库存 += qty）
    int rollbackPreDeduct(@Param("id") Long id, @Param("qty") Integer qty);

    // 最终扣减（预扣库存确认扣减）
    int finalizeDeduct(@Param("id") Long id, @Param("qty") Integer qty);

}
