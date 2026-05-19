package com.FoodSystem.wx.utils;


import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Map;

public class JwtUtil {

    /**
     * 生成JWT
     *
     * @param secretKey 秘钥
     * @param ttlMillis 过期时间（毫秒）
     * @param claims    自定义数据
     */
    public static String createJWT(String secretKey, long ttlMillis, Map<String, Object> claims) {

        // 生成密钥对象
        SecretKey key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));

        long nowMillis = System.currentTimeMillis();
        Date exp = new Date(nowMillis + ttlMillis);

        return Jwts.builder()
                .setClaims(claims)
                .setExpiration(exp)
                .signWith(io.jsonwebtoken.SignatureAlgorithm.HS256, key)
                .compact();
    }


    /**
     * 解析 JWT
     *
     * @param secretKey 密钥
     * @param token     token
     * @return claims
     */
    public static Claims parseJWT(String secretKey, String token) {

        SecretKey key = Keys.hmacShaKeyFor(secretKey.getBytes(StandardCharsets.UTF_8));

        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }


}
