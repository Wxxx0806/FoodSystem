package com.FoodSystem.wx.service;

import com.FoodSystem.wx.dto.EmployeeRequest;
import com.FoodSystem.wx.dto.EmployeeUpdateRequest;
import com.FoodSystem.wx.entity.Employee;
import com.FoodSystem.wx.entity.result.PageResult;


public interface EmployeeService {
    /**
     * 新增员工
     *
     * @param req
     * @return
     */
    Employee create(EmployeeRequest req);

    /**
     * 更新员工信息
     *
     * @param req
     * @return
     */
    Employee update(EmployeeUpdateRequest req);

    /**
     * 分页查询员工
     *
     * @param page
     * @param pageSize
     * @param name
     * @return
     */
    PageResult pageQuery(int page, int pageSize, String name);

    /**
     * 统计员工数量
     *
     * @return
     */
    Employee getById(Long id);

    /**
     * 删除员工
     *
     * @param id
     */
    void deleteById(Long id);

    /**
     * 更新员工状态
     *
     * @param id
     * @param status
     */
    void changeStatus(Long id, Integer status);


    Employee login(String username, String password);
}
