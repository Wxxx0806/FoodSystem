package com.FoodSystem.wx.config;

import com.FoodSystem.wx.interceptor.JwtTokenAdminInterceptor;
import com.FoodSystem.wx.json.JacksonObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.*;

import java.util.List;

@Configuration
public class WebMvcConfiguration implements WebMvcConfigurer {

    public static Logger log = LoggerFactory.getLogger(WebMvcConfiguration.class);
    @Autowired
    private JwtTokenAdminInterceptor jwtTokenAdminInterceptor;

    @Value("${file.upload.path:D:/FoodSystem/upload}")
    private String uploadPath;

    /**
     * 注册 JWT 拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(jwtTokenAdminInterceptor)
                // 只拦截后台管理接口
                .addPathPatterns("/admin/**", "/dish/**", "/employee/**", "/orders/**", "/statistics/**", "/upload/**")
                // 登录、静态资源、错误页等不拦截
                .excludePathPatterns("/login", "/images/**");// 登录接口和图片访问
    }

    /**
     * 设置静态资源映射（防止 Swagger、静态资源 404）
     */
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/resources/static/index.html")
                .addResourceLocations("classpath:/META-INF/resources/");

        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");

        // 映射上传的图片文件（从配置文件读取路径）
        // 确保路径以 / 结尾，且使用正确的格式
        String imagePath = uploadPath.endsWith("/") ? uploadPath : uploadPath + "/";
        // Windows路径需要转换为 file:// 格式，并确保使用 / 分隔符
        if (!imagePath.startsWith("/") && !imagePath.contains(":")) {
            // 如果是相对路径，转换为绝对路径
            imagePath = System.getProperty("user.dir") + "/" + imagePath;
        }
        // 统一使用 / 分隔符，并添加 file: 前缀
        String filePath = "file:" + imagePath.replace("\\", "/");
        log.info("图片静态资源映射路径: {}", filePath);
        registry.addResourceHandler("/images/**")
                .addResourceLocations(filePath);
    }

    /**
     * 使用自定义 Jackson 消息转换器
     */
    @Override
    public void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        //创建一个消息转换器
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        //需要为消息转换器设置一个对象转换器，对象转换器可以将java对象序列化为json数据
        converter.setObjectMapper(new JacksonObjectMapper());
        //将自己的消息转换器加入容器
        converters.add(0, converter);
    }

}
