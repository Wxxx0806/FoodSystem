<template>
  <div class="user-layout-container">
    <!-- 顶部导航栏 - 用户风格 -->
    <header class="user-top-header">
      <div class="header-left">
        <div class="logo-section">
          <el-icon class="logo-icon"><Food /></el-icon>

          <span class="logo-text">美食点餐</span>
        </div>
      </div>
      <div class="header-right">
        <div class="header-actions">
          <el-button 
            text 
            :type="$route.path === '/menu' ? 'primary' : ''" 
            @click="$router.push('/menu')"
            class="header-btn"
          >
            <el-icon class="btn-icon"><DishDot /></el-icon>

            <span>点餐</span>
          </el-button>
        </div>
        <div class="user-info">
          <el-avatar :size="36" class="user-avatar">
            {{ userName?.charAt(0) || 'U' }}
          </el-avatar>
          <span class="user-name">{{ userName || '用户' }}</span>
        </div>
      </div>
    </header>

    <div class="layout-body">
      <!-- 左侧边栏 - 用户专用 -->
      <aside class="user-sidebar">
        <div class="sidebar-header">
          <h3 class="sidebar-title">我的中心</h3>
        </div>
        <nav class="sidebar-nav">
          <div 
            class="nav-item" 
            :class="{ active: $route.path === '/orders' }"
            @click="$router.push('/orders')"
          >
            <el-icon class="nav-icon"><List /></el-icon>

            <span class="nav-text">我的订单</span>
          </div>
          <div class="nav-divider"></div>
          <div 
            class="nav-item logout-item" 
            @click="handleLogout"
          >
            <el-icon class="nav-icon"><SwitchButton /></el-icon>

            <span class="nav-text">退出登录</span>
          </div>
        </nav>
      </aside>

      <!-- 主内容区 -->
      <main class="user-main-content">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import {
  Food, DishDot, List, SwitchButton
} from '@element-plus/icons-vue';

const router = useRouter();

const userName = computed(() => {
  return localStorage.getItem('userName') || '用户';
});

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm('确定要退出登录吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    });
    
    localStorage.removeItem('role');
    localStorage.removeItem('userId');
    localStorage.removeItem('userName');
    localStorage.removeItem('userPhone');
    ElMessage.success('已退出登录');
    router.push('/login?type=user');
  } catch {
    // 用户取消
  }
};
</script>

<style scoped>
.user-layout-container {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 顶部导航栏 */
.user-top-header {
  height: 70px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 32px;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-left {
  display: flex;
  align-items: center;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  font-size: 32px;
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.logo-text {
  font-size: 24px;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-actions {
  display: flex;
  align-items: center;
}

.header-btn {
  font-weight: 600;
  font-size: 15px;
  padding: 8px 16px;
  border-radius: 20px;
  transition: all 0.3s ease;
}

.header-btn:hover {
  background: rgba(102, 126, 234, 0.1);
  transform: translateY(-2px);
}

.header-btn.el-button--primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-icon {
  margin-right: 6px;
  font-size: 16px;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 16px;
  border-radius: 20px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  cursor: pointer;
  transition: all 0.3s ease;
}

.user-info:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.user-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 700;
}

.user-name {
  font-weight: 600;
  color: #2d3748;
  font-size: 15px;
}

/* 布局主体 */
.layout-body {
  flex: 1;
  display: flex;
  overflow: hidden;
}

/* 左侧边栏 */
.user-sidebar {
  width: 220px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  box-shadow: 2px 0 20px rgba(0, 0, 0, 0.08);
  display: flex;
  flex-direction: column;
  padding: 24px 0;
}

.sidebar-header {
  padding: 0 24px 20px;
  border-bottom: 2px solid #e2e8f0;
  margin-bottom: 16px;
}

.sidebar-title {
  font-size: 18px;
  font-weight: 700;
  color: #2d3748;
  margin: 0;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.sidebar-nav {
  flex: 1;
  padding: 0 12px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  margin: 4px 0;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #4a5568;
  font-weight: 500;
  font-size: 15px;
}

.nav-item:hover {
  background: linear-gradient(135deg, #f5f7fa 0%, #e2e8f0 100%);
  transform: translateX(4px);
  color: #667eea;
}

.nav-item.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.nav-item.active .nav-icon {
  transform: scale(1.2);
}

.nav-icon {
  font-size: 20px;
  display: inline-block;
  transition: transform 0.3s ease;
}

.nav-text {
  flex: 1;
}

.nav-divider {
  height: 1px;
  background: linear-gradient(90deg, transparent, #e2e8f0, transparent);
  margin: 16px 12px;
}

.logout-item {
  color: #e53e3e;
  margin-top: 8px;
}

.logout-item:hover {
  background: linear-gradient(135deg, #fed7d7 0%, #fc8181 100%);
  color: #c53030;
}

/* 主内容区 */
.user-main-content {
  flex: 1;
  overflow-y: auto;
  background: linear-gradient(to bottom, #f7fafc 0%, #edf2f7 100%);
  padding: 24px;
  position: relative;
}

/* 滚动条样式 */
.user-main-content::-webkit-scrollbar {
  width: 8px;
}

.user-main-content::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.user-main-content::-webkit-scrollbar-thumb {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 4px;
}

.user-main-content::-webkit-scrollbar-thumb:hover {
  background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
}

/* 响应式设计 */
@media (max-width: 768px) {
  .user-sidebar {
    width: 180px;
  }
  
  .logo-text {
    font-size: 20px;
  }
  
  .user-name {
    display: none;
  }
}
</style>
