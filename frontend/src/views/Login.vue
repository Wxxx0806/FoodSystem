<template>
  <div class="login-container">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <!-- 登录卡片 -->
    <div class="login-card">
      <!-- 标题区域 -->
      <div class="login-header">
        <div class="logo-section">
          <el-icon class="logo-icon"><Shop /></el-icon>
          <h1 class="system-title">在线点餐系统</h1>
          <p class="system-subtitle">欢迎登录</p>
        </div>
      </div>

      <!-- 登录表单区域 -->
      <div class="login-content">
        <el-tabs v-model="activeTab" class="login-tabs" @tab-change="handleTabChange">
          <el-tab-pane label="员工登录" name="employee">
            <el-form
              :model="employeeForm"
              :rules="rules"
              ref="employeeFormRef"
              label-width="0"
              class="login-form"
            >
              <el-form-item prop="username">
                <el-input
                  v-model="employeeForm.username"
                  placeholder="请输入员工账号"
                  size="large"
                  class="login-input"
                >
                  <template #prefix>
                    <el-icon><User /></el-icon>
                  </template>
                </el-input>
              </el-form-item>
              <el-form-item prop="password">
                <el-input
                  v-model="employeeForm.password"
                  type="password"
                  placeholder="请输入密码"
                  show-password
                  size="large"
                  class="login-input"
                  @keyup.enter="onEmployeeSubmit"
                >
                  <template #prefix>
                    <el-icon><Lock /></el-icon>
                  </template>
                </el-input>
              </el-form-item>
              <el-form-item>
                <el-button
                  type="primary"
                  size="large"
                  class="login-button"
                  :loading="employeeLoading"
                  @click="onEmployeeSubmit"
                >
                  <el-icon v-if="!employeeLoading"><ArrowRight /></el-icon>
                  <span>员工登录</span>
                </el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>

          <el-tab-pane label="用户登录" name="user">
            <el-form
              :model="userForm"
              :rules="userRules"
              ref="userFormRef"
              label-width="0"
              class="login-form"
            >
              <el-form-item prop="username">
                <el-input
                  v-model="userForm.username"
                  placeholder="请输入用户名"
                  size="large"
                  class="login-input"
                >
                  <template #prefix>
                    <el-icon><User /></el-icon>
                  </template>
                </el-input>
              </el-form-item>
              <el-form-item prop="phone">
                <el-input
                  v-model="userForm.phone"
                  placeholder="请输入手机号"
                  size="large"
                  class="login-input"
                  @keyup.enter="onUserSubmit"
                >
                  <template #prefix>
                    <el-icon><Phone /></el-icon>
                  </template>
                </el-input>
              </el-form-item>
              <el-form-item>
                <el-button
                  type="primary"
                  size="large"
                  class="login-button"
                  :loading="userLoading"
                  @click="onUserSubmit"
                >
                  <el-icon v-if="!userLoading"><ArrowRight /></el-icon>
                  <span>用户登录</span>
                </el-button>
              </el-form-item>
            </el-form>
          </el-tab-pane>
        </el-tabs>
      </div>

      <!-- 底部提示 -->
      <div class="login-footer">
        <p class="footer-tip">请选择对应的登录方式</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { ElMessage } from 'element-plus';
import {
  User,
  Lock,
  Phone,
  ArrowRight,
  Shop
} from '@element-plus/icons-vue';
import { login, userLogin } from '@/api';

const router = useRouter();
const route = useRoute();

const activeTab = ref('employee');
const employeeLoading = ref(false);
const userLoading = ref(false);

const employeeFormRef = ref();
const userFormRef = ref();

const employeeForm = ref({
  username: '',
  password: ''
});

const userForm = ref({
  username: '',
  phone: ''
});

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
};

const userRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    {
      pattern: /^1[3-9]\d{9}$/,
      message: '请输入正确的手机号',
      trigger: 'blur'
    }
  ]
};

const handleTabChange = (tabName) => {
  // 切换标签时清空表单验证状态
  if (tabName === 'employee') {
    employeeFormRef.value?.clearValidate();
  } else {
    userFormRef.value?.clearValidate();
  }
};

const onEmployeeSubmit = () => {
  employeeFormRef.value.validate(async (valid) => {
    if (!valid) return;
    employeeLoading.value = true;
    try {
      const data = await login(employeeForm.value);
      localStorage.setItem('token', data.token);
      localStorage.setItem('role', 'employee');
      window.dispatchEvent(new Event('role-changed'));
      ElMessage.success('员工登录成功');
      router.push('/admin/dishes');
    } catch (e) {
      // 错误已在 api 拦截器中处理
    } finally {
      employeeLoading.value = false;
    }
  });
};

const onUserSubmit = () => {
  userFormRef.value.validate(async (valid) => {
    if (!valid) return;
    userLoading.value = true;
    try {
      const data = await userLogin(userForm.value);
      localStorage.removeItem('token');
      localStorage.setItem('role', 'user');
      localStorage.setItem('userId', String(data.id));
      localStorage.setItem('userName', data.name || userForm.value.username);
      localStorage.setItem('userPhone', data.phone || userForm.value.phone);
      window.dispatchEvent(new Event('role-changed'));
      ElMessage.success('用户登录成功');
      router.push('/menu');
    } catch (e) {
      // 错误已在 api 拦截器中处理
    } finally {
      userLoading.value = false;
    }
  });
};

onMounted(() => {
  // 允许通过路由参数控制默认选中的登录类型
  if (route.query.type === 'user') {
    activeTab.value = 'user';
  } else if (route.query.type === 'employee') {
    activeTab.value = 'employee';
  }
});
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
  padding: 20px;
  overflow: hidden;
}

@keyframes gradientShift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

/* 背景装饰圆圈 */
.background-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  pointer-events: none;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  animation: float 20s infinite ease-in-out;
}

.circle-1 {
  width: 300px;
  height: 300px;
  top: -150px;
  right: -150px;
  animation-delay: 0s;
}

.circle-2 {
  width: 200px;
  height: 200px;
  bottom: -100px;
  left: -100px;
  animation-delay: 5s;
}

.circle-3 {
  width: 150px;
  height: 150px;
  top: 50%;
  left: 10%;
  animation-delay: 10s;
}

@keyframes float {
  0%,
  100% {
    transform: translate(0, 0) scale(1);
  }
  33% {
    transform: translate(30px, -30px) scale(1.1);
  }
  66% {
    transform: translate(-20px, 20px) scale(0.9);
  }
}

/* 登录卡片 */
.login-card {
  width: 100%;
  max-width: 480px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  overflow: hidden;
  position: relative;
  z-index: 1;
  animation: slideUp 0.6s ease-out;
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 标题区域 */
.login-header {
  padding: 40px 40px 30px;
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.logo-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  font-size: 56px;
  color: white;
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%,
  100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.system-title {
  margin: 0;
  font-size: 28px;
  font-weight: 700;
  letter-spacing: 1px;
}

.system-subtitle {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
  font-weight: 400;
}

/* 登录内容区域 */
.login-content {
  padding: 40px;
}

.login-tabs {
  width: 100%;
}

.login-tabs :deep(.el-tabs__header) {
  margin-bottom: 30px;
}

.login-tabs :deep(.el-tabs__nav-wrap::after) {
  display: none;
}

.login-tabs :deep(.el-tabs__item) {
  font-size: 16px;
  font-weight: 600;
  padding: 0 30px;
  height: 50px;
  line-height: 50px;
  color: #64748b;
  transition: all 0.3s;
}

.login-tabs :deep(.el-tabs__item.is-active) {
  color: #667eea;
}

.login-tabs :deep(.el-tabs__active-bar) {
  background: linear-gradient(90deg, #667eea, #764ba2);
  height: 3px;
}

.login-form {
  margin-top: 20px;
}

.login-form :deep(.el-form-item) {
  margin-bottom: 24px;
}

.login-input {
  width: 100%;
}

.login-input :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
  padding: 12px 16px;
}

.login-input :deep(.el-input__wrapper:hover) {
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.login-input :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
  border-color: #667eea;
}

.login-input :deep(.el-input__prefix) {
  color: #667eea;
  font-size: 18px;
}

.login-button {
  width: 100%;
  height: 50px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 12px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  transition: all 0.3s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.login-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
}

.login-button:active {
  transform: translateY(0);
}

.login-button :deep(.el-icon) {
  font-size: 18px;
}

/* 底部提示 */
.login-footer {
  padding: 20px 40px 30px;
  text-align: center;
  border-top: 1px solid #e2e8f0;
}

.footer-tip {
  margin: 0;
  font-size: 13px;
  color: #94a3b8;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .login-card {
    max-width: 100%;
    border-radius: 16px;
  }

  .login-header {
    padding: 30px 20px 20px;
  }

  .system-title {
    font-size: 24px;
  }

  .login-content {
    padding: 30px 20px;
  }

  .login-tabs :deep(.el-tabs__item) {
    padding: 0 15px;
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .login-container {
    padding: 10px;
  }

  .login-header {
    padding: 24px 16px 16px;
  }

  .logo-icon {
    font-size: 48px;
  }

  .system-title {
    font-size: 20px;
  }

  .login-content {
    padding: 24px 16px;
  }

  .login-footer {
    padding: 16px;
  }
}
</style>
