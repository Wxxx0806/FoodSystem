package com.FoodSystem.wx.mapper;

import com.FoodSystem.wx.entity.Employee;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface EmployeeMapper {
    Employee getById(@Param("id") Long id);

    Employee getByUsername(@Param("username") String username);


    void update(Employee employee);

    void deleteById(@Param("id") Long id);

    List<Employee> pageQuery(@Param("name") String name);

}
