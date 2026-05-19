package com.FoodSystem.wx.controller;

import com.FoodSystem.wx.entity.Employee;
import com.FoodSystem.wx.entity.User;
import com.FoodSystem.wx.entity.result.Result;
import com.FoodSystem.wx.properties.JwtProperties;
import com.FoodSystem.wx.service.EmployeeService;
import com.FoodSystem.wx.service.UserService;
import com.FoodSystem.wx.utils.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
public class LoginController {
    public static Logger log = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    private EmployeeService employeeService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtProperties jwtProperties;

    /**
     * 员工登录
     *
     * @param loginForm
     * @return
     */
    @PostMapping("/login")
    public Result<Map<String, String>> login(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String password = loginForm.get("password");

        // 查询员工是否存在且密码正确
        Employee employee = employeeService.login(username, password);
        if (employee == null) {
            return Result.error("用户名或密码错误");
        }

        // 生成JWT令牌
        Map<String, Object> claims = new HashMap<>();
        claims.put("id", employee.getId());
        claims.put("username", employee.getUsername());

        String token = JwtUtil.createJWT(
                jwtProperties.getAdminSecretKey(),
                jwtProperties.getAdminTtl(),
                claims
        );

        // 在控制台返回令牌
        log.info("生成的JWT Token: {}", token);
        Map<String, String> data = new HashMap<>();
        data.put("token", token);

        return Result.success("登录成功",data);

    }

    /**
     * 用户登录（根据姓名+手机号，无需密码）
     */
    @PostMapping("/user/login")
    public Result<Map<String, Object>> userLogin(@RequestBody Map<String, String> loginForm) {
        String username = loginForm.get("username");
        String phone = loginForm.get("phone");

        if (username == null || phone == null) {
            return Result.error("用户名和手机号不能为空");
        }

        User user = userService.login(username, phone);
        if (user == null) {
            return Result.error("未找到该用户，请确认姓名和手机号是否正确");
        }

        Map<String, Object> data = new HashMap<>();
        data.put("id", user.getId());
        data.put("name", user.getName());
        data.put("phone", user.getPhone());

        return Result.success("登录成功", data);
    }

    /**
     * TODO 退出登录
     *
     * @return
     */
    @PostMapping("/logout")
    public Result<String> logout() {
        log.info("员工执行退出登录操作");

        // 因为 JWT 是存放在前端的，后端无法强制失效
        return Result.success();
    }


}
