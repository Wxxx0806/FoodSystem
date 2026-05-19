<template>
  <div class="admin-page">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <el-icon style="vertical-align: middle; margin-right: 6px;">
            <Document />
          </el-icon>
          订单管理
        </h2>

        <p class="page-subtitle">查看和管理系统中的所有订单</p>
      </div>
    </div>

    <!-- 操作栏 -->
    <div class="admin-card">
      <div class="toolbar">
        <div class="search-section">
          <el-input v-model="query.userId" placeholder="搜索用户ID" size="large" style="width:280px" clearable
                    class="search-input" @clear="loadData">
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>

          <el-button type="primary" size="large" @click="loadData">
            <span>查询</span>
          </el-button>
        </div>
        <div class="action-section">
          <el-button size="large" @click="loadData" class="refresh-btn">
            <el-icon><Refresh /></el-icon>
            <span>刷新</span>

          </el-button>
        </div>
      </div>

      <!-- 数据表格 -->
      <div class="table-wrapper">
        <el-table :data="tableData" size="default" border stripe class="admin-table">
          <el-table-column prop="id" label="订单ID" width="90" />
          <el-table-column prop="number" label="订单号" width="200" />
          <el-table-column prop="userId" label="用户ID" width="100" />
          <el-table-column prop="userName" label="用户名称" width="120" />
          <el-table-column prop="phone" label="手机号" width="130" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="statusType(row.status)">{{ statusText(row.status) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="amount" label="金额" width="100" align="right">
            <template #default="{ row }">
              <span class="amount-text">¥{{ row.amount }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="orderTime" label="下单时间" width="180" />
          <el-table-column label="操作" width="180" fixed="right">
            <template #default="{ row }">
              <el-button link size="small" type="primary" @click="showDetail(row)">
                详情
              </el-button>
              <el-button link size="small" type="success" :disabled="row.payStatus === 1" @click="pay(row)">
                支付
              </el-button>
              <el-button link size="small" type="danger" :disabled="row.status === 3 || row.status === 4"
                @click="cancel(row)">
                取消
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 分页 -->
      <div class="pagination-wrapper">
        <el-pagination layout="prev, pager, next, jumper, total" :total="pager.total" :page-size="pager.pageSize"
          v-model:current-page="pager.page" @current-change="loadData" background class="admin-pagination" />
      </div>
    </div>

    <!-- 订单详情对话框 -->
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
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Search, Refresh, Document } from '@element-plus/icons-vue';

import {
  fetchOrdersAll,
  fetchOrdersByUser,
  fetchOrderDetail,
  payOrder,
  cancelOrder
} from '@/api';

const query = reactive({ userId: '' });
const tableData = ref([]);
const pager = reactive({ page: 1, pageSize: 10, total: 0 });

const detailVisible = ref(false);
const currentDetail = ref([]);

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

const loadData = async () => {
  try {
    let orders = [];
    if (query.userId) {
      orders = await fetchOrdersByUser(Number(query.userId));
    } else {
      orders = await fetchOrdersAll();
    }
    // 分页处理
    pager.total = orders.length;
    const start = (pager.page - 1) * pager.pageSize;
    const end = start + pager.pageSize;
    tableData.value = orders.slice(start, end);
  } catch (e) {
    tableData.value = [];
    pager.total = 0;
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
    ElMessage.success('支付成功');
    loadData();
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
    await cancelOrder(row.id, '管理员取消');
    ElMessage.success('订单已取消');
    loadData();
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error('取消失败');
    }
  }
};

onMounted(loadData);
</script>

<style scoped>
.admin-page {
  min-height: 100%;
}

.page-header {
  background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
  border-radius: 12px;
  padding: 24px 32px;
  margin-bottom: 24px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}

.header-content {
  color: #fff;
}

.page-title {
  margin: 0 0 8px 0;
  font-size: 24px;
  font-weight: 700;
  color: #fff;
}

.page-subtitle {
  margin: 0;
  font-size: 14px;
  color: #cbd5e1;
  opacity: 0.9;
}

.admin-card {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 20px;
  border-bottom: 2px solid #f1f5f9;
}

.search-section {
  display: flex;
  gap: 12px;
  align-items: center;
}

.search-input {
  border-radius: 8px;
}

.action-section {
  display: flex;
  gap: 12px;
}

.refresh-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  border-radius: 8px;
  font-weight: 600;
  background: #f1f5f9;
  border-color: #e2e8f0;
  color: #475569;
}

.refresh-btn:hover {
  background: #e2e8f0;
  border-color: #cbd5e1;
}

.table-wrapper {
  margin-top: 16px;
}

.admin-table {
  width: 100%;
}

.admin-table :deep(.el-table__header) {
  background-color: #f8fafc;
}

.admin-table :deep(.el-table__header th) {
  background-color: #f8fafc;
  color: #1e293b;
  font-weight: 600;
  border-color: #e2e8f0;
}

.admin-table :deep(.el-table__body tr:hover) {
  background-color: #f8fafc;
}

.amount-text {
  font-weight: 600;
  color: #3b82f6;
}

.pagination-wrapper {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
}

.admin-pagination {
  padding: 16px 0;
}

.admin-pagination :deep(.el-pagination__total) {
  font-weight: 600;
  color: #475569;
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
  color: #3b82f6;
}
</style>
