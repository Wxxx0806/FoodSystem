<template>
  <div class="user-orders-page">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="welcome-content">
        <h2>
          <el-icon style="margin-right:6px"><List /></el-icon>
          我的订单
        </h2>

        <p>查看您的订单状态和历史记录</p>
      </div>
    </div>

    <div class="card orders-card">
      <div class="orders-header">
        <div class="user-info-section">
          <div class="user-avatar">
            <el-icon size="28"><UserFilled /></el-icon>
          </div>

          <div class="user-details">
            <div class="user-name">{{ userName || '用户' }}</div>
            <div class="user-id">用户ID: {{ userId || '-' }}</div>
          </div>
        </div>
        <el-button type="primary" size="large" @click="loadOrders" circle>
          <el-icon>
            <Refresh />
          </el-icon>
        </el-button>
      </div>

      <el-empty v-if="orders.length === 0" description="暂无订单，快去点餐吧！" :image-size="120">
        <el-button type="primary" @click="goMenu">去点餐</el-button>
      </el-empty>

      <div v-else class="orders-list">
        <div v-for="order in orders" :key="order.id" class="order-card">
          <div class="order-header">
            <div class="order-info">
              <div class="order-number">
                <el-icon>
                  <Document />
                </el-icon>
                订单号: {{ order.number }}
              </div>
              <div class="order-time">
                <el-icon>
                  <Clock />
                </el-icon>
                {{ formatTime(order.orderTime) }}
              </div>
            </div>
            <el-tag :type="statusType(order.status)" size="large" class="status-tag">
              {{ statusText(order.status) }}
            </el-tag>
          </div>

          <div class="order-body">
            <div class="order-amount">
              <span class="amount-label">订单金额</span>
              <span class="amount-value">¥{{ order.amount }}</span>
            </div>

            <div class="order-actions">
              <el-button type="primary" size="small" @click="showDetail(order)">
                <el-icon>
                  <View />
                </el-icon>
                查看详情
              </el-button>
              <el-button type="success" size="small" :disabled="!canPay(order)" @click="pay(order)">
                <el-icon>
                  <Money />
                </el-icon>
                支付
              </el-button>
              <el-button type="danger" size="small" :disabled="order.status !== 0 && order.status !== 1"
                @click="cancel(order)">
                <el-icon>
                  <Close />
                </el-icon>
                取消订单
              </el-button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <el-dialog v-model="detailVisible" title="订单详情" width="600px" class="order-detail-dialog">
      <div class="detail-content">
        <el-table :data="currentDetail" size="small" border>
          <el-table-column prop="name" label="菜品名称" min-width="150" />
          <el-table-column prop="number" label="数量" width="80" align="center" />
          <el-table-column prop="price" label="单价" width="100" align="right">
            <template #default="{ row }">
              ¥{{ formatPrice(row.price) }}
            </template>
          </el-table-column>
          <el-table-column prop="subtotal" label="小计" width="120" align="right">
            <template #default="{ row }">
              <span class="subtotal-text">¥{{ formatPrice(row.subtotal) }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage, ElMessageBox } from 'element-plus';
import {
  Refresh, Document, Clock, View, Money, Close,
  List, UserFilled
} from '@element-plus/icons-vue';

import {
  fetchOrdersByUser,
  fetchOrderDetail,
  payOrder,
  cancelOrder
} from '@/api';

const router = useRouter();

const userId = ref(Number(localStorage.getItem('userId') || 0));
const userName = ref(localStorage.getItem('userName') || '');
const orders = ref([]);
const detailVisible = ref(false);
const currentDetail = ref([]);

// 判断订单是否可以支付
const canPay = (order) => {
  // 已支付的订单不能再次支付
  if (order.payStatus === 1) {
    return false;
  }
  // 只有状态为 0（待支付）或 1（待付款）的订单可以支付
  // 状态 2 及以上（已完成、已取消、已退款等）不能支付
  return order.status === 0 || order.status === 1;
};

const statusText = (s) => {
  const statusMap = {
    0: '待支付',
    1: '待付款',
    2: '已完成',
    3: '已取消',
    4: '已取消',
    5: '已退款'
  };
  return statusMap[s] || '未知';
};

const statusType = (s) => {
  const typeMap = {
    0: 'warning',
    1: 'warning',
    2: 'success',
    3: 'info',
    4: 'info',
    5: 'info'
  };
  return typeMap[s] || 'info';
};

const formatTime = (timeStr) => {
  if (!timeStr) return '-';
  const date = new Date(timeStr);
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const loadOrders = async () => {
  if (!userId.value) {
    orders.value = [];
    return;
  }
  try {
    orders.value = await fetchOrdersByUser(userId.value);
  } catch (e) {
    orders.value = [];
  }
};

const formatPrice = (price) => {
  if (price == null || price === undefined) return '0.00';
  const num = typeof price === 'string' ? parseFloat(price) : price;
  return num.toFixed(2);
};

const showDetail = async (row) => {
  try {
    currentDetail.value = await fetchOrderDetail(row.id);
    detailVisible.value = true;
  } catch (e) {
    ElMessage.error('获取订单详情失败');
  }
};

const pay = async (row) => {
  try {
    await ElMessageBox.confirm('确认支付该订单吗？', '支付确认', {
      type: 'warning',
      confirmButtonText: '确认支付',
      cancelButtonText: '取消'
    });
    await payOrder(row.id);
    ElMessage.success('支付成功！');

    loadOrders();
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('支付失败');
    }
  }
};

const cancel = async (row) => {
  try {
    await ElMessageBox.confirm('确认取消该订单吗？取消后无法恢复。', '取消订单', {
      type: 'warning',
      confirmButtonText: '确认取消',
      cancelButtonText: '我再想想'
    });
    await cancelOrder(row.id, '用户主动取消');
    ElMessage.success('订单已取消');
    loadOrders();
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('取消失败');
    }
  }
};

const goMenu = () => {
  router.push('/menu');
};

onMounted(loadOrders);
</script>

<style scoped>
.user-orders-page {
  max-width: 1200px;
  margin: 0 auto;
}

.welcome-banner {
  background: linear-gradient(135deg, #ff6b6b 0%, #ff8e53 100%);
  border-radius: 16px;
  padding: 32px;
  margin-bottom: 24px;
  box-shadow: 0 8px 24px rgba(255, 107, 107, 0.3);
  color: white;
}

.welcome-content h2 {
  margin: 0 0 8px 0;
  font-size: 28px;
  font-weight: 700;
}

.welcome-content p {
  margin: 0;
  font-size: 16px;
  opacity: 0.95;
}

.orders-card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.orders-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f7fafc;
}

.user-info-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.user-avatar {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: linear-gradient(135deg, #ff6b6b, #ff8e53);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  box-shadow: 0 4px 12px rgba(255, 107, 107, 0.3);
}

.user-details {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.user-name {
  font-size: 18px;
  font-weight: 700;
  color: #2d3748;
}

.user-id {
  font-size: 14px;
  color: #718096;
}

.orders-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.order-card {
  background: #f7fafc;
  border-radius: 12px;
  padding: 20px;
  border: 2px solid transparent;
  transition: all 0.3s ease;
}

.order-card:hover {
  border-color: #ff6b6b;
  box-shadow: 0 4px 16px rgba(255, 107, 107, 0.15);
  transform: translateY(-2px);
}

.order-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.order-number {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 600;
  color: #2d3748;
}

.order-time {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #718096;
}

.status-tag {
  font-weight: 600;
  padding: 6px 16px;
}

.order-body {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.order-amount {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.amount-label {
  font-size: 14px;
  color: #718096;
}

.amount-value {
  font-size: 24px;
  font-weight: 700;
  color: #ff6b6b;
}

.order-actions {
  display: flex;
  gap: 8px;
}

.order-detail-dialog :deep(.el-dialog__body) {
  padding: 20px;
}

.detail-content {
  max-height: 400px;
  overflow-y: auto;
}

.subtotal-text {
  font-weight: 600;
  color: #ff6b6b;
}
</style>
