<template>
  <div class="admin-page">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <el-icon style="vertical-align: middle; margin-right: 6px;">
            <Dish />
          </el-icon>
          菜品管理
        </h2>

        <p class="page-subtitle">管理系统中的所有菜品信息</p>
      </div>
    </div>

    <!-- 操作栏 -->
    <div class="admin-card">
      <div class="toolbar">
        <div class="search-section">
          <el-input v-model="query.name" placeholder="搜索菜品名称..." size="large" clearable>
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
            新增菜品
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
          <el-table-column prop="name" label="名称" />
          <el-table-column prop="price" label="价格" width="100" />
          <el-table-column prop="status" label="状态" width="90">
            <template #default="{ row }">
              <el-tag :type="row.status === 1 ? 'success' : 'info'">
                {{ row.status === 1 ? '起售' : '停售' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="stock" label="库存" width="90" />
          <el-table-column label="操作" width="180">
            <template #default="{ row }">
              <el-button link size="small" @click="openDialog(row)">编辑</el-button>
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
        <el-form-item label="名称" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="分类ID" prop="categoryId">
          <el-input v-model.number="form.categoryId" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="form.price" :min="0" :step="1" />
        </el-form-item>
        <el-form-item label="菜品图片">
          <div class="image-upload-section">
            <div class="image-uploader-wrapper">
              <input
                ref="fileInputRef"
                type="file"
                accept="image/*"
                style="display: none"
                @change="handleFileSelect"
              />
              <div class="image-uploader" @click="triggerFileInput">
                <img v-if="form.image" :src="form.image" class="dish-image" />
                <div v-else class="upload-placeholder">
                  <el-icon class="image-uploader-icon"><Plus /></el-icon>
                  <div class="upload-text">点击上传</div>
                  <div class="upload-hint">支持 JPG、PNG 格式</div>
                </div>
              </div>
            </div>
            <div class="image-tips">
              <el-input 
                v-model="form.image" 
                placeholder="或直接输入图片URL" 
                style="margin-top: 10px;"
                clearable
              />
              <div class="tips-text">支持 JPG、PNG 格式，大小不超过 5MB</div>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" />
        </el-form-item>
        <el-form-item label="状态">
          <el-switch v-model="form.status" :active-value="1" :inactive-value="0" active-text="起售" inactive-text="停售" />
        </el-form-item>
        <el-form-item label="库存">
          <el-input-number v-model="form.stock" :min="0" />
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
import { ref, reactive, onMounted, computed } from 'vue';
import { ElMessage, ElMessageBox } from 'element-plus';
import { Plus, Search, Refresh, Dish } from '@element-plus/icons-vue';
import {
  fetchDishPage,
  createDish,
  updateDish,
  deleteDish,
  uploadImage
} from '@/api';

const query = reactive({ name: '' });
const tableData = ref([]);
const pager = reactive({ page: 1, pageSize: 10, total: 0 });

const dialogVisible = ref(false);
const dialogTitle = ref('');
const formRef = ref();
const fileInputRef = ref();
const form = reactive({
  id: null,
  name: '',
  categoryId: '',
  price: 0,
  image: '',
  description: '',
  status: 1,
  stock: 0
});

const rules = {
  name: [{ required: true, message: '请输入名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }]
};

const loadData = async () => {
  const res = await fetchDishPage({
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
    dialogTitle.value = '编辑菜品';
  } else {
    Object.assign(form, {
      id: null,
      name: '',
      categoryId: '',
      price: 0,
      image: '',
      description: '',
      status: 1,
      stock: 0
    });
    dialogTitle.value = '新增菜品';
  }
  dialogVisible.value = true;
};

const save = () => {
  formRef.value.validate(async (valid) => {
    if (!valid) return;
    try {
      if (form.id) {
        await updateDish(form);
        ElMessage.success('更新成功');
      } else {
        await createDish(form);
        ElMessage.success('新增成功');
      }
      dialogVisible.value = false;
      loadData();
    } catch (e) {
      /* 已提示 */
    }
  });
};

const remove = async (id) => {
  await ElMessageBox.confirm('确认删除该菜品吗？', '提示', { type: 'warning' });
  await deleteDish(id);
  ElMessage.success('删除成功');
  loadData();
};

// 图片上传相关
const triggerFileInput = () => {
  fileInputRef.value?.click();
};

const handleFileSelect = async (event) => {
  const file = event.target.files?.[0];
  if (!file) {
    return;
  }

  // 验证文件类型
  const isImage = file.type.startsWith('image/');
  if (!isImage) {
    ElMessage.error('只能上传图片文件！');
    event.target.value = ''; // 清空选择
    return;
  }

  // 验证文件大小
  const isLt5M = file.size / 1024 / 1024 < 5;
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB！');
    event.target.value = ''; // 清空选择
    return;
  }

  // 开始上传
  try {
    console.log('开始上传图片:', file.name);
    
    const formData = new FormData();
    formData.append('file', file);
    
    const token = localStorage.getItem('token');
    const response = await fetch('/api/upload/image', {
      method: 'POST',
      headers: {
        'token': token || ''
      },
      body: formData
    });
    
    const result = await response.json();
    console.log('上传响应:', result);
    
    if (result.code === 1 && result.data) {
      form.image = result.data;
      ElMessage.success('图片上传成功');
    } else {
      ElMessage.error(result.msg || '图片上传失败');
    }
  } catch (error) {
    console.error('图片上传错误:', error);
    ElMessage.error('图片上传失败：' + (error.message || '网络错误'));
  } finally {
    // 清空文件选择，允许重复选择同一文件
    event.target.value = '';
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

/* 图片上传样式 */
.image-upload-section {
  width: 100%;
}

.image-uploader-wrapper {
  position: relative;
  width: 178px;
  height: 178px;
}

.image-uploader {
  width: 100%;
  height: 100%;
  border: 1px dashed #d9d9d9;
  border-radius: 8px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: all 0.3s ease;
  background: #fafafa;
  display: flex;
  align-items: center;
  justify-content: center;
}

.image-uploader:hover {
  border-color: #409eff;
  background: #f0f9ff;
}

.upload-content {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.dish-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.upload-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 20px;
}

.image-uploader-icon {
  font-size: 36px;
  color: #8c939d;
}

.upload-text {
  font-size: 14px;
  color: #666;
  font-weight: 500;
}

.upload-hint {
  font-size: 12px;
  color: #999;
}

.image-tips {
  margin-top: 8px;
}

.tips-text {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}
</style>