<template>
  <div class="admin-page">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <el-icon style="vertical-align: middle; margin-right: 6px;">
            <User />
          </el-icon>
          员工管理
        </h2>

        <p class="page-subtitle">管理系统中的所有员工信息</p>
      </div>
    </div>

    <!-- 操作栏 -->
    <div class="admin-card">
      <div class="toolbar">
        <div class="search-section">
          <el-input v-model="query.name" placeholder="搜索员工姓名" size="large"
                    style="width:280px" clearable class="search-input">
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>

          <el-button type="primary" size="large" @click="loadData">
            <span>查询</span>
          </el-button>
        </div>
        <div class="action-section">
          <el-button type="primary" size="large" @click="openDialog()" class="add-btn">
            <el-icon><Plus /></el-icon>
            <span>新增员工</span>

          </el-button>
          <el-button size="large" @click="loadData" class="refresh-btn">
            <el-icon><Refresh /></el-icon>
            刷新

          </el-button>
        </div>
      </div>

      <!-- 数据表格 -->
      <div class="table-wrapper">
        <el-table :data="tableData" size="default" border stripe class="admin-table">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="name" label="姓名" />
          <el-table-column prop="username" label="用户名" />
          <el-table-column prop="phone" label="手机号" />
          <el-table-column prop="sex" label="性别" width="80" />
          <el-table-column prop="status" label="状态" width="90">
            <template #default="{ row }">
              <el-tag :type="row.status === 1 ? 'success' : 'info'">
                {{ row.status === 1 ? '启用' : '禁用' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="240">
            <template #default="{ row }">
              <el-button link size="small" @click="openDialog(row)">编辑</el-button>
              <el-button link size="small" type="warning" @click="toggleStatus(row)">
                {{ row.status === 1 ? '禁用' : '启用' }}
              </el-button>
              <el-button link size="small" type="danger" @click="remove(row.id)">删除</el-button>
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

    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="520px">
      <el-form :model="form" label-width="90px" :rules="rules" ref="formRef">
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="用户名" prop="username" v-if="!form.id">
          <el-input v-model="form.username" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!form.id">
          <el-input v-model="form.password" show-password />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item label="性别">
          <el-select v-model="form.sex" placeholder="请选择">
            <el-option label="男" value="男" />
            <el-option label="女" value="女" />
          </el-select>
        </el-form-item>
        <el-form-item label="身份证号">
          <el-input v-model="form.idNumber" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="save">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { User, Search, Plus, Refresh } from '@element-plus/icons-vue';

import {
  fetchEmployeePage,
  createEmployee,
  updateEmployee,
  deleteEmployee,
  changeEmployeeStatus
} from '@/api';

const query = reactive({ name: '' });
const tableData = ref([]);
const pager = reactive({ page: 1, pageSize: 10, total: 0 });

const dialogVisible = ref(false);
const dialogTitle = ref('');
const formRef = ref();
const form = reactive({
  id: null,
  name: '',
  username: '',
  password: '',
  phone: '',
  sex: '',
  idNumber: ''
});

const rules = {
  name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
};

const loadData = async () => {
  const res = await fetchEmployeePage({
    page: pager.page,
    pageSize: pager.pageSize,
    name: query.name || undefined
  });
  tableData.value = res.list || [];
  pager.total = res.total || 0;
};

const openDialog = (row) => {
  if (row) {
    Object.assign(form, row);
    dialogTitle.value = '编辑员工';
  } else {
    Object.assign(form, {
      id: null,
      name: '',
      username: '',
      password: '',
      phone: '',
      sex: '',
      idNumber: ''
    });
    dialogTitle.value = '新增员工';
  }
  dialogVisible.value = true;
};

const save = () => {
  formRef.value.validate(async (valid) => {
    if (!valid) return;
    try {
      if (form.id) {
        await updateEmployee(form);
        ElMessage.success('更新成功');
      } else {
        await createEmployee(form);
        ElMessage.success('新增成功');
      }
      dialogVisible.value = false;
      loadData();
    } catch (e) {
      /* 已提示 */
    }
  });
};

const toggleStatus = async (row) => {
  const newStatus = row.status === 1 ? 0 : 1;
  await changeEmployeeStatus(row.id, newStatus);
  ElMessage.success('状态已更新');
  loadData();
};

const remove = async (id) => {
  await ElMessageBox.confirm('确认删除该员工吗？', '提示', { type: 'warning' });
  await deleteEmployee(id);
  ElMessage.success('删除成功');
  loadData();
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

.add-btn,
.refresh-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  border-radius: 8px;
  font-weight: 600;
}

.add-btn {
  background: linear-gradient(135deg, #3b82f6, #2563eb);
  border: none;
}

.add-btn:hover {
  background: linear-gradient(135deg, #2563eb, #1d4ed8);
}

.refresh-btn {
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
</style>