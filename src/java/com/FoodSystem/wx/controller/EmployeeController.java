package com.FoodSystem.wx.controller;


import com.FoodSystem.wx.dto.EmployeeRequest;
import com.FoodSystem.wx.dto.EmployeeUpdateRequest;
import com.FoodSystem.wx.entity.Employee;
import com.FoodSystem.wx.entity.result.PageResult;
import com.FoodSystem.wx.entity.result.Result;
import com.FoodSystem.wx.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/admin/employee")
public class EmployeeController {

    @Autowired
    private EmployeeService employeeService;

    /**
     * 新增员工
     */
    @PostMapping
    public Result<Employee> create(@RequestBody EmployeeRequest req) {
        Employee e = employeeService.create(req);
        return Result.success(e);
    }

    /**
     * 修改员工信息
     */
    @PutMapping
    public Result<Employee> update(@RequestBody EmployeeUpdateRequest req) {
        Employee e = employeeService.update(req);
        if (e == null) {
            return Result.error("员工不存在");
        }
        return Result.success(e);
    }

    /**
     * 分页查询员工列表
     */
    @GetMapping("/page")
    public Result<PageResult> pageQuery(
            @RequestParam int page,
            @RequestParam int pageSize,
            @RequestParam(required = false) String name) {

        PageResult pageResult = employeeService.pageQuery(page, pageSize, name);
        return Result.success(pageResult);
    }

    /**
     * 根据ID查询员工
     */
    @GetMapping("/{id}")
    public Result<Employee> getById(@PathVariable Long id) {
        Employee e = employeeService.getById(id);
        if (e == null) {
            return Result.error("未找到该员工");
        }
        return Result.success(e);
    }

    /**
     * 根据ID删除员工
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        employeeService.deleteById(id);
        return Result.success();
    }

    /**
     * 启用/禁用员工账号
     */
    @PostMapping("/status/{status}")
    public Result<Void> changeStatus(@RequestParam Long id, @PathVariable Integer status) {
        employeeService.changeStatus(id, status);
        return Result.success();
    }


}
