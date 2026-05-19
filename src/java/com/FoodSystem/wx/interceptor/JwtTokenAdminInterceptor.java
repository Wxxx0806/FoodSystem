package com.FoodSystem.wx.interceptor;


import com.FoodSystem.wx.context.BaseContext;
import com.FoodSystem.wx.properties.JwtProperties;
import com.FoodSystem.wx.utils.JwtUtil;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;


/**
 * jwt令牌校验的拦截器
 */
@Component

public class JwtTokenAdminInterceptor implements HandlerInterceptor {

    @Autowired
    private JwtProperties jwtProperties;

    public static Logger log = LoggerFactory.getLogger(JwtTokenAdminInterceptor.class);

    /**
     * 校验jwt
     *
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws Exception
     */
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        log.info("进入拦截器");

        //判断当前拦截到的是Controller的方法还是其他资源
        if (!(handler instanceof HandlerMethod)) {
            //当前拦截到的不是动态方法，直接放行
            return true;
        }

        String uri = request.getRequestURI();

        // 放行静态资源
        if (uri.contains("html") || uri.contains("css") || uri.contains("js")) {
            return true;
        }

        // 放行前台点餐和订单相关接口：用户无需员工 token
        if (uri.startsWith("/dish/") && "GET".equalsIgnoreCase(request.getMethod())) {
            return true;
        }
        
        // 放行普通用户订单相关接口（不包括统计接口，统计接口需要员工权限）
        if (uri.startsWith("/orders/") && !uri.startsWith("/orders/statistics/")) {
            log.info("放行普通订单接口: {}", uri);
            return true;
        }
        
        // 放行图片访问接口
        if (uri.startsWith("/images/")) {
            return true;
        }

        // 统计接口需要员工token验证
        if (uri.startsWith("/orders/statistics/")) {
            log.info("统计接口需要token验证: {}", uri);
            //1、从请求头中获取令牌
            String token = request.getHeader(jwtProperties.getAdminTokenName());
            log.info("jwt令牌:{}", token);
            
            if (token == null || token.isEmpty()) {
                log.warn("统计接口缺少token: {}", uri);
                response.setStatus(401);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"code\":0,\"msg\":\"未登录或登录过期，请重新登录\"}");
                return false;
            }

            //2、校验令牌
            try {
                log.info("jwt校验:{}", token);
                Claims claims = JwtUtil.parseJWT(jwtProperties.getAdminSecretKey(), token);
                Long userId = Long.valueOf(claims.get("id").toString());
                log.info("当前员工id：{}", userId);
                // 将当前登录用户的id保存到当前线程的LocalThread中
                BaseContext.setCurrentId(userId);
                log.info("jwt令牌校验成功，放行统计接口: {}", uri);
                //3、通过，放行
                return true;
            } catch (Exception ex) {
                log.error("jwt令牌校验失败: {}", ex.getMessage());
                //4、不通过，响应401状态码
                response.setStatus(401);
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"code\":0,\"msg\":\"token无效或已过期\"}");
                return false;
            }
        }

        // 其他需要token的接口
        //1、从请求头中获取令牌
        String token = request.getHeader(jwtProperties.getAdminTokenName());
        log.info("jwt令牌:{}", token);

        //2、校验令牌
        try {
            log.info("jwt校验:{}", token);
            Claims claims = JwtUtil.parseJWT(jwtProperties.getAdminSecretKey(), token);
            Long userId = Long.valueOf(claims.get("id").toString());
            log.info("当前员工id：{}", userId);
            // 将当前登录用户的id保存到当前线程的LocalThread中
            BaseContext.setCurrentId(userId);
            log.info("jwt令牌校验成功");
            //3、通过，放行
            return true;
        } catch (Exception ex) {
            log.error("jwt令牌校验失败: {}", ex.getMessage());
            //4、不通过，响应401状态码
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":0,\"msg\":\"未登录或登录过期\"}");
            return false;
        }
    }
}
