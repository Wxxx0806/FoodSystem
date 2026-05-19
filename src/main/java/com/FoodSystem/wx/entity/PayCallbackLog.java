package com.FoodSystem.wx.entity;

import java.time.LocalDateTime;

public class PayCallbackLog {
    private Long id;
    private Long orderId;
    private String provider;
    private String callbackNo;
    private String payload;
    private LocalDateTime createdAt;

    public PayCallbackLog(Long id, Long orderId, String provider, String callbackNo, String payload, LocalDateTime createdAt) {
        this.id = id;
        this.orderId = orderId;
        this.provider = provider;
        this.callbackNo = callbackNo;
        this.payload = payload;
        this.createdAt = createdAt;
    }

    public PayCallbackLog() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOrderId() {
        return orderId;
    }

    public void setOrderId(Long orderId) {
        this.orderId = orderId;
    }

    public String getProvider() {
        return provider;
    }

    public void setProvider(String provider) {
        this.provider = provider;
    }

    public String getCallbackNo() {
        return callbackNo;
    }

    public void setCallbackNo(String callbackNo) {
        this.callbackNo = callbackNo;
    }

    public String getPayload() {
        return payload;
    }

    public void setPayload(String payload) {
        this.payload = payload;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
