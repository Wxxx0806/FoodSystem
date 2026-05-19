<template>
  <!-- 登录页面 - 不显示任何布局 -->
  <router-view v-if="isLoginPage" />
  
  <!-- 管理员布局 - 员工登录时显示 -->
  <el-container v-else-if="!isUser" style="min-height: 100vh" key="admin-layout">
    <!-- 顶部导航栏 -->
    <el-header height="64px" class="employee-header app-header">
      <div class="logo">
        <span>在线点餐管理信息系统</span>
      </div>
      <div class="nav-actions">
        <el-button link @click="$router.push('/admin/dishes')">菜品管理</el-button>
        <el-button link @click="$router.push('/admin/employees')">员工管理</el-button>
        <el-button link @click="$router.push('/admin/orders')">我的订单</el-button>
        <el-button link @click="$router.push('/chart')">数据可视化</el-button>
        <el-button link type="danger" @click="logout">登出</el-button>
      </div>
    </el-header>

    <el-container>
      <!-- 侧边栏：员工专用 -->
      <el-aside width="240px" class="employee-aside">
        <div class="aside-header">
          <div class="admin-logo">
            <el-icon class="logo-icon"><Setting /></el-icon>
            <span class="logo-text">管理后台</span>
          </div>
        </div>
        <el-menu class="admin-menu" :default-active="$route.path" router background-color="#1e293b" text-color="#cbd5e1"
          active-text-color="#60a5fa">
          <el-menu-item index="/admin/dishes" class="menu-item">
            <el-icon class="menu-icon"><Dish /></el-icon>
            <span class="menu-text">菜品管理</span>
          </el-menu-item>
          <el-menu-item index="/admin/orders" class="menu-item">
            <el-icon class="menu-icon"><List /></el-icon>
            <span class="menu-text">订单状态</span>
          </el-menu-item>
          <el-menu-item index="/admin/employees" class="menu-item">
            <el-icon class="menu-icon"><User /></el-icon>
            <span class="menu-text">员工管理</span>
          </el-menu-item>
          <el-menu-item index="/chart" class="menu-item">
            <el-icon class="menu-icon"><DataLine /></el-icon>
            <span class="menu-text">数据可视化</span>
          </el-menu-item>
        </el-menu>
        <div class="menu-divider"></div>
        <div class="menu-item logout-menu-item" @click="logout">
          <el-icon class="menu-icon"><SwitchButton /></el-icon>
          <span class="menu-text">退出登录</span>
        </div>
      </el-aside>

      <!-- 主内容区 -->
      <el-main class="employee-main main-content">
        <div class="employee-container page-container">
          <router-view />
        </div>
      </el-main>
    </el-container>
  </el-container>

  <!-- 用户布局 - 用户登录时显示 -->
  <UserLayout v-else key="user-layout" />
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import UserLayout from '@/layouts/UserLayout.vue';
import {
  Dish,
  User,
  DataLine,
  List,
  Setting,
  SwitchButton
} from '@element-plus/icons-vue'
const router = useRouter();
const route = useRoute();

// 使用 ref 来存储角色，确保响应式
const isUser = ref(false);

// 判断是否为登录页面
const isLoginPage = computed(() => {
  return route.path === '/login';
});

// 更新角色判断函数 - 明确判断只有 'user' 才是用户
const updateRole = () => {
  const role = localStorage.getItem('role');
  // 只有 role === 'user' 时才显示用户布局，其他情况（包括 'employee'、null 或 undefined）都显示管理员布局
  const shouldBeUser = role === 'user';
  if (isUser.value !== shouldBeUser) {
    isUser.value = shouldBeUser;
    console.log('角色更新:', role, 'isUser:', isUser.value);
  }
};

// 监听路由变化，确保角色判断正确
watch(() => route.path, () => {
  updateRole();
}, { immediate: true });

// 监听自定义角色变化事件
const handleRoleChanged = () => {
  updateRole();
};

// 监听 storage 事件（跨标签页）
const handleStorageChange = (e) => {
  if (e.key === 'role') {
    updateRole();
  }
};

// 初始化时检查角色
onMounted(() => {
  updateRole();
  window.addEventListener('storage', handleStorageChange);
  window.addEventListener('role-changed', handleRoleChanged);

  // 定期检查（作为备用方案，确保角色判断正确）
  const interval = setInterval(updateRole, 500);
  window.__roleCheckInterval = interval;
});

onUnmounted(() => {
  window.removeEventListener('storage', handleStorageChange);
  window.removeEventListener('role-changed', handleRoleChanged);
  if (window.__roleCheckInterval) {
    clearInterval(window.__roleCheckInterval);
  }
});

const logout = async () => {
  const role = localStorage.getItem('role');
  localStorage.removeItem('token');
  localStorage.removeItem('role');
  localStorage.removeItem('userId');
  localStorage.removeItem('userName');
  localStorage.removeItem('userPhone');
  isUser.value = false;
  ElMessage.success('已登出');
  if (role === 'user') {
    router.push('/login?type=user');
  } else {
    router.push('/login?type=employee');
  }
};
</script>

<style scoped>
/* 管理员布局样式 */
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: #fff;
  padding: 0 24px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.logo {
  font-weight: 800;
  letter-spacing: 0.5px;
  font-size: 18px;
}

.nav-actions .el-button {
  color: #fff;
  font-weight: 600;
  margin-left: 8px;
}

/* 员工后台样式（专业商务风格） */
.employee-header {
  background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
}

.employee-aside {
  background: #1e293b;
  border-right: none;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
  display: flex;
  flex-direction: column;
}

.aside-header {
  padding: 20px;
  border-bottom: 1px solid #334155;
}

.admin-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  color: #fff;
}

.logo-icon {
  font-size: 24px;
}

.logo-text {
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.admin-menu {
  border: none;
  padding: 16px 0;
}

.admin-menu .menu-item {
  margin: 4px 12px;
  border-radius: 8px;
  height: 48px;
  line-height: 48px;
}

.admin-menu .menu-item:hover {
  background-color: #334155 !important;
}

.admin-menu .menu-item.is-active {
  background-color: #3b82f6 !important;
  color: #fff !important;
}

.menu-icon {
  font-size: 18px;
  margin-right: 12px;
  display: inline-block;
  width: 24px;
  text-align: center;
}

.menu-text {
  font-weight: 500;
  font-size: 15px;
}

.menu-divider {
  height: 1px;
  background: #334155;
  margin: 8px 12px;
}

.logout-menu-item {
  margin: 4px 12px;
  border-radius: 8px;
  height: 48px;
  line-height: 48px;
  padding: 0 20px;
  cursor: pointer;
  color: #ef4444;
  display: flex;
  align-items: center;
  transition: all 0.3s ease;
  margin-top: auto;
}

.logout-menu-item:hover {
  background-color: #7f1d1d !important;
  color: #fff !important;
  transform: translateX(4px);
}

.employee-main {
  background: #f1f5f9;
}

.employee-container {
  padding: 24px;
  background: transparent;
}
</style>
