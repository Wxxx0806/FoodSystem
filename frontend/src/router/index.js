import { createRouter, createWebHistory } from 'vue-router';
import Login from '@/views/Login.vue';
import DishList from '@/views/DishList.vue';
import Orders from '@/views/Orders.vue';
import AdminDishes from '@/views/AdminDishes.vue';
import AdminEmployees from '@/views/AdminEmployees.vue';
import AdminOrders from '@/views/AdminOrders.vue';
import Chart from '@/views/Chart.vue';

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', redirect: '/login' },
    { path: '/login', component: Login },
    // 普通用户端：点餐 & 我的订单
    { path: '/menu', component: DishList, meta: { requiresUser: true } },
    { path: '/orders', component: Orders, meta: { requiresUser: true } },
    {
      path: '/admin',
      redirect: '/admin/dishes'
    },
    {
      path: '/admin/dishes',
      component: AdminDishes,
      meta: { requiresEmployee: true }
    },
    {
      path: '/admin/employees',
      component: AdminEmployees,
      meta: { requiresEmployee: true }
    },
    {
      path: '/admin/orders',
      component: AdminOrders,
      meta: { requiresEmployee: true }
    },
    {
      path: '/chart',
      component: Chart,
      meta: { requiresEmployee: true }
    }
  ]
});

router.beforeEach((to, _from, next) => {
  const token = localStorage.getItem('token');
  const role = localStorage.getItem('role');

  // 员工后台路由需要员工角色 + token
  if (to.meta.requiresEmployee) {
    if (role === 'employee' && token) {
      next();
    } else {
      next({ path: '/login', query: { type: 'employee' } });
    }
    return;
  }

  // 前台用户路由需要用户角色
  if (to.meta.requiresUser) {
    if (role === 'user') {
      next();
    } else {
      next({ path: '/login', query: { type: 'user' } });
    }
    return;
  }

  // 已经登录时访问 /login，根据角色跳转到对应首页
  if (to.path === '/login') {
    if (role === 'employee' && token) {
      next('/admin/dishes');
      return;
    }
    if (role === 'user') {
      next('/menu');
      return;
    }
  }

  next();
});

export default router;




