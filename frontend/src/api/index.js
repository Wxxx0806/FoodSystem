import axios from 'axios';
import { ElMessage } from 'element-plus';

const api = axios.create({
  baseURL: '/api',
  timeout: 8000
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token');
  if (token) {
    // 后端拦截器读取 jwtProperties.adminTokenName=token
    config.headers.token = token;
  }
  return config;
});

api.interceptors.response.use(
  (res) => {
    const { data } = res;
    // 如果直接返回数据（不是Result格式），直接返回
    if (data && typeof data === 'object' && !data.hasOwnProperty('code')) {
      return data;
    }
    // 如果是Result格式，检查code
    if (data && data.code === 1) {
      // Result.success 返回的数据在 data 字段中
      return data.data !== undefined ? data.data : data;
    }
    // code 不为 1，表示失败
    const errorMsg = (data && data.msg) || '请求失败';
    ElMessage.error(errorMsg);
    return Promise.reject(new Error(errorMsg));
  },
  (err) => {
    console.error('API请求失败详情:', {
      message: err.message,
      code: err.code,
      response: err.response,
      config: err.config
    });
    
    const status = err.response?.status;
    const responseData = err.response?.data;
    let msg = '网络异常';
    
    if (status === 401) {
      msg = '未登录或登录过期，请重新登录';
      // 清除本地存储并跳转到登录页
      localStorage.clear();
      window.location.href = '/login?type=employee';
    } else if (status === 403) {
      msg = '没有权限访问该资源';
    } else if (status === 404) {
      msg = '请求的资源不存在';
    } else if (status >= 500) {
      msg = '服务器内部错误，请稍后重试';
    } else if (err.code === 'ECONNABORTED') {
      msg = '请求超时，请稍后重试';
    } else if (err.message === 'Network Error') {
      msg = '网络连接失败，请检查后端服务是否启动';
    } else if (responseData && responseData.msg) {
      msg = responseData.msg;
    }
    
    ElMessage.error(msg);
    return Promise.reject(err);
  }
);

export const login = (payload) => api.post('/login', payload);

// 前台用户登录
export const userLogin = (payload) => api.post('/user/login', payload);

// 菜品
export const fetchDishPage = (params) => api.get('/dish/page', { params });
export const fetchDishAll = () => api.get('/dish/all');
export const createDish = (payload) => api.post('/dish', payload);
export const updateDish = (payload) => api.put('/dish', payload);
export const deleteDish = (id) => api.delete(`/dish/${id}`);

// 员工
export const fetchEmployeePage = (params) =>
  api.get('/admin/employee/page', { params });
export const createEmployee = (payload) => api.post('/admin/employee', payload);
export const updateEmployee = (payload) => api.put('/admin/employee', payload);
export const deleteEmployee = (id) => api.delete(`/admin/employee/${id}`);
export const changeEmployeeStatus = (id, status) =>
  api.post(`/admin/employee/status/${status}`, null, { params: { id } });

// 订单
export const createOrder = (userId, dishMap) =>
  api.post('/orders/create', dishMap, { params: { userId } });
export const payOrder = (orderId) =>
  api.post('/orders/paySuccess', null, { params: { orderId } });
export const cancelOrder = (orderId, reason) =>
  api.post('/orders/cancel', null, { params: { orderId, reason } });
export const fetchOrdersByUser = (userId) =>
  api.get('/orders/list', { params: { userId } });
export const fetchOrdersAll = () => api.get('/orders/list');
export const fetchOrderDetail = (orderId) =>
  api.get('/orders/detail', { params: { orderId } });

// 统计数据
export const getOrderTrend = (days = 7) =>
  api.get('/orders/statistics/trend', { params: { days } });
export const getOrderStatusDistribution = () =>
  api.get('/orders/statistics/status');
export const getOrderHourDistribution = () =>
  api.get('/orders/statistics/hour');

// 文件上传
export const uploadImage = (file) => {
  const formData = new FormData();
  formData.append('file', file);
  return api.post('/upload/image', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  });
};

export default api;




