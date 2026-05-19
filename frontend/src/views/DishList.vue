<template>
  <div class="user-menu-page">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="welcome-content">
        <h2>
          <el-icon style="margin-right:6px"><Bell /></el-icon>
          欢迎，{{ userName || '用户' }}！
        </h2>

        <p>选择您喜欢的菜品，享受美食时光</p>
      </div>
    </div>

    <div class="page-title">
      <el-icon style="margin-right:6px"><Food /></el-icon>
      菜品菜单
    </div>

    <el-row :gutter="20">
      <el-col :span="16">
        <div class="card dish-list-card">
          <div class="search-bar">
            <el-input v-model="keyword" placeholder="搜索您想吃的菜品..." clearable size="large" @input="loadDishes"
              class="search-input">
              <template #prefix>
                <el-icon>
                  <Search />
                </el-icon>
              </template>
            </el-input>
            <el-button type="primary" size="large" @click="loadDishes" circle>
              <el-icon>
                <Refresh />
              </el-icon>
            </el-button>
          </div>
          <el-row :gutter="16" class="dish-grid">
            <el-col v-for="dish in dishes" :key="dish.id" :span="8">
              <div class="dish-card-wrapper">
                <el-card class="dish-card" shadow="hover">
                  <div class="dish-image-container">
                    <img 
                      v-if="dish.image" 
                      :src="getImageUrl(dish.image)" 
                      :alt="dish.name"
                      class="dish-image"
                      @error="handleImageError($event)"
                    />
                    <div class="dish-image-placeholder" :class="{ 'show-placeholder': !dish.image }">
                      <el-icon size="48"><Bowl /></el-icon>

                    </div>
                  </div>
                  <div class="dish-info">
                    <div class="dish-name">{{ dish.name }}</div>
                    <div class="dish-desc">{{ dish.description || '美味佳肴，值得品尝' }}</div>
                    <div class="dish-footer">
                      <div class="dish-meta">
                        <span class="price">¥{{ dish.price }}</span>
                        <span class="stock" :class="{ 'low-stock': dish.stock < 10 }">
                          库存: {{ dish.stock ?? '-' }}
                        </span>
                      </div>
                      <el-button type="primary" size="small" @click="addToCart(dish)" class="add-btn"
                        :disabled="dish.stock <= 0">
                        <el-icon>
                          <Plus />
                        </el-icon>
                        加入购物车
                      </el-button>
                    </div>
                  </div>
                </el-card>
              </div>
            </el-col>
          </el-row>
        </div>
      </el-col>

      <el-col :span="8">
        <div class="card cart-card">
          <div class="cart-header">
            <h3>
              <el-icon style="margin-right:6px"><ShoppingCartFull /></el-icon>
              我的购物车
            </h3>

          </div>
          <div class="user-info-badge">
            <el-icon>
              <User />
            </el-icon>
            <span>用户ID: {{ userId }}</span>
          </div>
          <div class="cart-list" v-if="cartList.length > 0">
            <div v-for="item in cartList" :key="item.id" class="cart-item">
              <div class="cart-item-info">
                <div class="cart-item-name">{{ item.name }}</div>
                <div class="cart-item-price">¥{{ item.price.toFixed(2) }}</div>
              </div>
              <div class="cart-item-actions">
                <el-input-number v-model="item.qty" :min="1" size="small" @change="(val) => updateQty(item.id, val)"
                  controls-position="right" />
                <el-button link type="danger" size="small" @click="removeItem(item.id)" class="remove-btn">
                  <el-icon>
                    <Delete />
                  </el-icon>
                </el-button>
              </div>
              <div class="cart-item-subtotal">
                小计: ¥{{ (item.price * item.qty).toFixed(2) }}
              </div>
            </div>
          </div>
          <el-empty v-else description="购物车是空的，快去选点好吃的吧！" :image-size="100" />
          <div class="cart-footer">
            <div class="total-price">
              <span class="total-label">合计：</span>
              <span class="total-amount">¥{{ totalPrice.toFixed(2) }}</span>
            </div>
            <el-button type="success" size="large" :disabled="!cartList.length || !userId" @click="submitOrder"
              class="submit-btn">
              <el-icon>
                <ShoppingCartFull />
              </el-icon>
              立即下单
            </el-button>
          </div>
          <el-divider />
          <div class="recent-orders">
            <h4>
              <el-icon style="margin-right:6px"><List /></el-icon>
              最新订单
            </h4>

            <el-empty v-if="!lastOrder.length" description="暂无订单" :image-size="60" />
            <div v-else class="order-timeline">
              <div v-for="item in lastOrder" :key="item.id" class="order-item">
                <span class="order-dish">{{ item.name }}</span>
                <span class="order-qty">x{{ item.number }}</span>
                <span class="order-price">¥{{ item.subtotal }}</span>
              </div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { ElMessage } from 'element-plus';
import { Search, Refresh, Plus, User, Delete, ShoppingCartFull } from '@element-plus/icons-vue';
import { fetchDishPage, createOrder } from '@/api';

const router = useRouter();

const dishes = ref([]);
const keyword = ref('');
const cartMap = ref({});
const userId = ref(Number(localStorage.getItem('userId') || 1));
const userName = ref(localStorage.getItem('userName') || '');
const lastOrder = ref([]);

const cartList = computed(() => Object.values(cartMap.value));

const totalPrice = computed(() =>
  cartList.value.reduce((sum, item) => sum + item.price * item.qty, 0)
);

const loadDishes = async () => {
  const res = await fetchDishPage({
    page: 1,
    pageSize: 100,
    name: keyword.value || undefined
  });
  dishes.value = res.list || [];
};

// 获取图片完整URL
const getImageUrl = (imagePath) => {
  if (!imagePath) return '';
  // 如果已经是完整URL（http://或https://开头），直接返回
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath;
  }
  // 如果是以 /images/ 开头的路径，拼接服务器地址
  if (imagePath.startsWith('/images/')) {
    return `http://localhost:8080${imagePath}`;
  }
  // 如果是以 / 开头的其他路径，拼接服务器地址
  if (imagePath.startsWith('/')) {
    return `http://localhost:8080${imagePath}`;
  }
  // 否则认为是文件名，拼接完整路径
  return `http://localhost:8080/images/${imagePath}`;
};

// 处理图片加载失败
const handleImageError = (event) => {
  // 图片加载失败时，隐藏img标签，显示占位符
  const img = event.target;
  img.style.display = 'none';
  const container = img.parentElement;
  if (container) {
    const placeholder = container.querySelector('.dish-image-placeholder');
    if (placeholder) {
      placeholder.classList.add('show-placeholder');
    }
  }
};

const addToCart = (dish) => {
  if (!cartMap.value[dish.id]) {
    cartMap.value[dish.id] = {
      id: dish.id,
      name: dish.name,
      price: Number(dish.price),
      qty: 1
    };
  } else {
    cartMap.value[dish.id].qty += 1;
  }
  cartMap.value = { ...cartMap.value };
  ElMessage.success(`已将 ${dish.name} 加入购物车`);
};

const removeItem = (id) => {
  const item = cartMap.value[id];
  delete cartMap.value[id];
  cartMap.value = { ...cartMap.value };
  if (item) {
    ElMessage.success(`已移除 ${item.name}`);
  }
};

const updateQty = (id, val) => {
  if (!cartMap.value[id]) return;
  cartMap.value[id].qty = val;
  cartMap.value = { ...cartMap.value };
};

const submitOrder = async () => {
  const dishMap = {};
  cartList.value.forEach((item) => {
    dishMap[item.id] = item.qty;
  });
  try {
    const detail = await createOrder(userId.value, dishMap);
    lastOrder.value = detail;
    ElMessage.success('下单成功！请前往“我的订单”查看详情');

    cartMap.value = {};
  } catch (e) {
    /* 已提示 */
  }
};

onMounted(loadDishes);
</script>

<style scoped>
.user-menu-page {
  max-width: 1400px;
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

.page-title {
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 20px;
  color: #2d3748;
}

.dish-list-card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

.search-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.search-input {
  flex: 1;
}

.dish-grid {
  margin-top: 16px;
}

.dish-card-wrapper {
  margin-bottom: 20px;
}

.dish-card {
  border-radius: 12px;
  overflow: hidden;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.dish-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  border-color: #ff6b6b;
}

.dish-image-container {
  width: 100%;
  height: 140px;
  margin-bottom: 12px;
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
}

.dish-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  position: absolute;
  top: 0;
  left: 0;
}

.dish-image-placeholder {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #ffeaa7 0%, #fdcb6e 100%);
  display: none;
  align-items: center;
  justify-content: center;
  position: absolute;
  top: 0;
  left: 0;
  z-index: 1;
}

.dish-image-placeholder.show-placeholder {
  display: flex;
}

.dish-icon {
  font-size: 48px;
}

.dish-info {
  padding: 0 4px;
}

.dish-name {
  font-weight: 700;
  font-size: 18px;
  color: #2d3748;
  margin-bottom: 8px;
}

.dish-desc {
  color: #718096;
  font-size: 13px;
  margin-bottom: 12px;
  min-height: 36px;
  line-height: 1.5;
}

.dish-footer {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.dish-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.price {
  color: #ff6b6b;
  font-size: 20px;
  font-weight: 700;
}

.stock {
  color: #718096;
  font-size: 12px;
}

.stock.low-stock {
  color: #e53e3e;
  font-weight: 600;
}

.add-btn {
  width: 100%;
  background: linear-gradient(135deg, #ff6b6b, #ff8e53);
  border: none;
  font-weight: 600;
}

.add-btn:hover {
  background: linear-gradient(135deg, #ff5252, #ff7043);
}

.cart-card {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  position: sticky;
  top: 80px;
}

.cart-header h3 {
  margin: 0 0 16px 0;
  font-size: 20px;
  color: #2d3748;
}

.user-info-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: #fff5f5;
  border-radius: 8px;
  margin-bottom: 16px;
  color: #c53030;
  font-size: 14px;
}

.cart-list {
  max-height: 400px;
  overflow-y: auto;
  margin-bottom: 16px;
}

.cart-item {
  padding: 12px;
  background: #f7fafc;
  border-radius: 8px;
  margin-bottom: 12px;
}

.cart-item-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.cart-item-name {
  font-weight: 600;
  color: #2d3748;
}

.cart-item-price {
  color: #ff6b6b;
  font-weight: 600;
}

.cart-item-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.remove-btn {
  margin-left: auto;
}

.cart-item-subtotal {
  text-align: right;
  font-size: 12px;
  color: #718096;
}

.cart-footer {
  margin-top: 20px;
}

.total-price {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background: linear-gradient(135deg, #fff5f5, #fef9f3);
  border-radius: 8px;
  margin-bottom: 16px;
}

.total-label {
  font-size: 16px;
  font-weight: 600;
  color: #2d3748;
}

.total-amount {
  font-size: 24px;
  font-weight: 700;
  color: #ff6b6b;
}

.submit-btn {
  width: 100%;
  background: linear-gradient(135deg, #48bb78, #38a169);
  border: none;
  font-weight: 600;
  font-size: 16px;
  padding: 14px;
}

.submit-btn:hover {
  background: linear-gradient(135deg, #38a169, #2f855a);
}

.recent-orders {
  margin-top: 20px;
}

.recent-orders h4 {
  margin: 0 0 12px 0;
  font-size: 16px;
  color: #2d3748;
}

.order-timeline {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.order-item {
  display: flex;
  justify-content: space-between;
  padding: 8px 12px;
  background: #f7fafc;
  border-radius: 6px;
  font-size: 13px;
}

.order-dish {
  flex: 1;
  color: #2d3748;
}

.order-qty {
  color: #718096;
  margin: 0 8px;
}

.order-price {
  color: #ff6b6b;
  font-weight: 600;
}
</style>
