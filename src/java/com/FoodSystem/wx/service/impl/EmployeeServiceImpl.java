package com.FoodSystem.wx.service.impl;

import com.FoodSystem.wx.dto.EmployeeRequest;
import com.FoodSystem.wx.dto.EmployeeUpdateRequest;
import com.FoodSystem.wx.entity.Dish;
import com.FoodSystem.wx.entity.Employee;
import com.FoodSystem.wx.entity.result.PageResult;
import com.FoodSystem.wx.mapper.EmployeeMapper;
import com.FoodSystem.wx.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    /**
     * 创建员工
     *
     * @param req
     * @return
     */
    @Override
    public Employee create(EmployeeRequest req) {
        Employee emp = new Employee();
        emp.setName(req.getName());
        emp.setUsername(req.getUsername());
        emp.setPassword(req.getPassword()); // 需要可加密可不加密
        emp.setPhone(req.getPhone());
        emp.setSex(req.getSex());
        emp.setIdNumber(req.getIdNumber());
        emp.setStatus(1);  // 默认启用
        emp.setCreateTime(LocalDateTime.now());
        emp.setUpdateTime(LocalDateTime.now());
        emp.setCreateUser(1L); // 可从 BaseContext 拿
        emp.setUpdateUser(1L);

        employeeMapper.insert(emp);
        return emp;
    }

    /**
     * 更新员工信息
     *
     * @param req
     * @return
     */
    @Override
    public Employee update(EmployeeUpdateRequest req) {
        Employee exist = employeeMapper.getById(req.getId());
        if (exist == null) {
            return null;
        }

        if (req.getName() != null) exist.setName(req.getName());
        if (req.getPhone() != null) exist.setPhone(req.getPhone());
        if (req.getSex() != null) exist.setSex(req.getSex());
        if (req.getIdNumber() != null) exist.setIdNumber(req.getIdNumber());

        exist.setUpdateTime(LocalDateTime.now());
        exist.setUpdateUser(1L);

        employeeMapper.update(exist);
        return exist;
    }

    /**
     * 分页查询员工信息
     *
     * @param page
     * @param pageSize
     * @param name
     * @return
     */
    @Override
    public PageResult pageQuery(int page, int pageSize, String name) {
        // 计算起始索引
        int offset = (page - 1) * pageSize;

        // 查询数据列表
        List<Employee> employees = employeeMapper.pageQuery(name);

        // 计算总记录数
        int total = employees.size();

        // 创建分页结果对象
        PageResult pageResult = new PageResult();
        pageResult.setList(employees);
        pageResult.setTotal(total);
        pageResult.setPageNum(page);
        pageResult.setPageSize(pageSize);
        pageResult.setPages((int) Math.ceil((double) total / pageSize));

        return pageResult;
    }

    /**
     * 根据员工id查询员工信息
     *
     * @param id
     * @return
     */
    @Override
    public Employee getById(Long id) {
        return employeeMapper.getById(id);
    }

    /**
     * 根据员工id删除员工信息
     *
     * @param id
     */
    @Override
    public void deleteById(Long id) {
        employeeMapper.deleteById(id);
    }

    /**
     * 改变员工状态
     *
     * @param id
     * @param status
     */
    @Override
    public void changeStatus(Long id, Integer status) {
        Employee emp = employeeMapper.getById(id);
        if (emp == null) return;

        emp.setStatus(status);
        emp.setUpdateTime(LocalDateTime.now());
        emp.setUpdateUser(1L);

        employeeMapper.update(emp);
    }

    /**
     * 用户登录验证
     *
     * @param username 用户名
     * @param password 密码
     * @return 用户对象，若失败返回 null
     */
    public Employee login(String username, String password) {
        // 查找用户
        Employee employee = employeeMapper.getByUsername(username);
        if (employee == null) {
            return null;
        }

        // 验证密码（此处为简单明文对比，实际应使用加密如BCrypt）
        if (!employee.getPassword().equals(password)) {
            return null;
        }

        return employee;
    }
}
