package com.FoodSystem.wx.controller;

import com.FoodSystem.wx.config.WebMvcConfiguration;
import com.FoodSystem.wx.entity.result.Result;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@RequestMapping("/upload")
public class FileUploadController {
    public static Logger log = LoggerFactory.getLogger(WebMvcConfiguration.class);

    @Value("${file.upload.path:D:/FoodSystem/upload}")
    private String uploadPath;

    @Value("${file.upload.url:http://localhost:8080/images}")
    private String uploadUrl;

    /**
     * 上传图片
     */
    @PostMapping("/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            // 检查文件是否为空
            if (file.isEmpty()) {
                return Result.error("上传文件不能为空");
            }

            // 检查文件类型
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null) {
                return Result.error("文件名不能为空");
            }

            String extension = "";
            int lastDotIndex = originalFilename.lastIndexOf(".");
            if (lastDotIndex > 0) {
                extension = originalFilename.substring(lastDotIndex);
            }

            // 只允许图片格式
            String[] allowedExtensions = {".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"};
            boolean isAllowed = false;
            for (String ext : allowedExtensions) {
                if (extension.equalsIgnoreCase(ext)) {
                    isAllowed = true;
                    break;
                }
            }

            if (!isAllowed) {
                return Result.error("只支持图片格式：jpg, jpeg, png, gif, bmp, webp");
            }

            // 检查文件大小（限制为5MB）
            if (file.getSize() > 5 * 1024 * 1024) {
                return Result.error("图片大小不能超过5MB");
            }

            // 创建上传目录
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成唯一文件名
            String fileName = UUID.randomUUID().toString() + extension;
            Path filePath = Paths.get(uploadPath, fileName);

            // 保存文件
            Files.write(filePath, file.getBytes());

            // 返回访问URL
            String imageUrl = uploadUrl + "/" + fileName;
            log.info("图片上传成功: {}", imageUrl);

            return Result.success("上传成功", imageUrl);
        } catch (IOException e) {
            log.error("图片上传失败", e);
            return Result.error("图片上传失败：" + e.getMessage());
        }
    }
}
