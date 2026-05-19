<template>
  <div class="admin-page">
    <!-- 页面头部 -->
    <div class="page-header">
      <div class="header-content">
        <h2 class="page-title">
          <el-icon style="vertical-align: middle; margin-right: 6px;">
            <DataLine />
          </el-icon>
          数据可视化
        </h2>

        <p class="page-subtitle">查看系统运营数据和统计图表</p>
      </div>
      <div class="header-actions">
        <el-select v-model="trendDays" size="large" @change="loadTrendData" style="width: 150px">
          <el-option label="最近7天" :value="7" />
          <el-option label="最近15天" :value="15" />
          <el-option label="最近30天" :value="30" />
        </el-select>
      </div>
    </div>

    <!-- 图表卡片容器 -->
    <div class="charts-grid">
      <!-- 图表1: 订单 & 营业额趋势 -->
      <div class="admin-card chart-card">
        <div class="chart-title">
          <h3>
            <el-icon style="margin-right: 6px;"><TrendCharts /></el-icon>
            订单 & 营业额趋势
          </h3>

          <p>最近 {{ trendDays }} 天的订单量和营业额变化</p>
        </div>
        <div class="chart-container">
          <div ref="trendChartRef" class="chart"></div>
        </div>
      </div>

      <!-- 图表2: 订单状态分布 -->
      <div class="admin-card chart-card">
        <div class="chart-title">
          <h3>
            <el-icon style="margin-right: 6px;"><PieChart /></el-icon>
            订单状态分布
          </h3>

          <p>系统健康度：各状态订单占比</p>
        </div>
        <div class="chart-container">
          <div ref="statusChartRef" class="chart"></div>
        </div>
      </div>

      <!-- 图表3: 下单时间分布 -->
      <div class="admin-card chart-card full-width">
        <div class="chart-title">
          <h3>
            <el-icon style="margin-right: 6px;"><Clock /></el-icon>
            下单时间分布
          </h3>

          <p>24小时内各时段的订单分布情况</p>
        </div>
        <div class="chart-container">
          <div ref="hourChartRef" class="chart"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, onBeforeUnmount, ref, nextTick } from 'vue';
import { ElMessage } from 'element-plus';
import * as echarts from 'echarts';
import { DataLine, TrendCharts, PieChart, Clock } from '@element-plus/icons-vue';

import {
  getOrderTrend,
  getOrderStatusDistribution,
  getOrderHourDistribution
} from '@/api';

const trendDays = ref(7);
const trendChartRef = ref(null);
const statusChartRef = ref(null);
const hourChartRef = ref(null);

let trendChartInstance = null;
let statusChartInstance = null;
let hourChartInstance = null;

// 加载订单趋势数据
const loadTrendData = async () => {
  try {
    const data = await getOrderTrend(trendDays.value);
    if (!data || !Array.isArray(data)) {
      ElMessage.error('订单趋势数据格式错误');
      return;
    }
    renderTrendChart(data || []);
  } catch (e) {
    ElMessage.error('加载订单趋势数据失败');
    console.error('加载订单趋势数据错误:', e);
  }
};

// 渲染订单&营业额趋势折线图
const renderTrendChart = (data) => {
  if (!trendChartRef.value) return;

  if (!trendChartInstance) {
    trendChartInstance = echarts.init(trendChartRef.value);
  }

  // 处理数据：确保日期连续，没有数据的日期填充0
  const dates = [];
  const orderCounts = [];
  const amounts = [];

  // 生成日期范围
  const today = new Date();
  for (let i = trendDays.value - 1; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    const dateStr = date.toISOString().split('T')[0];
    dates.push(dateStr.substring(5)); // 只显示月-日

    // 查找对应日期的数据
    const item = data.find((d) => {
      // 处理可能的日期格式差异
      const itemDate = d.date || d.dateStr || '';
      return itemDate === dateStr || itemDate.startsWith(dateStr);
    });
    
    // 处理数据，确保转换为数字
    const orderCount = item ? (Number(item.orderCount) || Number(item.order_count) || 0) : 0;
    const totalAmount = item ? (Number(item.totalAmount) || Number(item.total_amount) || Number(item.total_amount) || 0) : 0;
    
    orderCounts.push(orderCount);
    amounts.push(totalAmount);
  }
  
  console.log('趋势数据:', { dates, orderCounts, amounts });

  trendChartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(30, 41, 59, 0.95)',
      borderColor: '#334155',
      textStyle: { color: '#fff' },
      formatter: (params) => {
        let result = `${params[0].axisValue}<br/>`;
        params.forEach((param) => {
          result += `${param.marker}${param.seriesName}: ${param.value}${param.seriesName === '营业额' ? '元' : '单'}<br/>`;
        });
        return result;
      }
    },
    legend: {
      data: ['订单量', '营业额'],
      top: 10,
      textStyle: { color: '#475569', fontWeight: 600 }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: dates,
      axisLine: { lineStyle: { color: '#cbd5e1' } },
      axisLabel: { color: '#64748b', rotate: 45 }
    },
    yAxis: [
      {
        type: 'value',
        name: '订单量',
        position: 'left',
        axisLine: { lineStyle: { color: '#cbd5e1' } },
        axisLabel: { color: '#64748b', formatter: '{value} 单' },
        splitLine: { lineStyle: { color: '#f1f5f9' } }
      },
      {
        type: 'value',
        name: '营业额(元)',
        position: 'right',
        axisLine: { lineStyle: { color: '#cbd5e1' } },
        axisLabel: { color: '#64748b', formatter: '{value} 元' },
        splitLine: { show: false }
      }
    ],
    series: [
      {
        name: '订单量',
        type: 'line',
        data: orderCounts,
        smooth: true,
        lineStyle: { color: '#3b82f6', width: 3 },
        itemStyle: { color: '#3b82f6' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(59, 130, 246, 0.3)' },
            { offset: 1, color: 'rgba(59, 130, 246, 0.1)' }
          ])
        },
        yAxisIndex: 0
      },
      {
        name: '营业额',
        type: 'line',
        data: amounts,
        smooth: true,
        lineStyle: { color: '#10b981', width: 3 },
        itemStyle: { color: '#10b981' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(16, 185, 129, 0.3)' },
            { offset: 1, color: 'rgba(16, 185, 129, 0.1)' }
          ])
        },
        yAxisIndex: 1
      }
    ]
  });
};

// 加载订单状态分布数据
const loadStatusData = async () => {
  try {
    const data = await getOrderStatusDistribution();
    if (!data || !Array.isArray(data)) {
      ElMessage.error('订单状态数据格式错误');
      return;
    }
    renderStatusChart(data || []);
  } catch (e) {
    ElMessage.error('加载订单状态数据失败');
    console.error('加载订单状态数据错误:', e);
  }
};

// 渲染订单状态分布饼图
const renderStatusChart = (data) => {
  if (!statusChartRef.value) return;

  if (!statusChartInstance) {
    statusChartInstance = echarts.init(statusChartRef.value);
  }

  const pieData = data.map((item) => ({
    value: Number(item.count || 0),
    name: item.statusName || item.status_name || '未知'
  })).filter(item => item.value > 0); // 过滤掉数量为0的状态

  // 如果没有数据，显示空状态
  if (pieData.length === 0 || pieData.every(item => item.value === 0)) {
    statusChartInstance.setOption({
      title: {
        text: '暂无数据',
        left: 'center',
        top: 'center',
        textStyle: { color: '#64748b', fontSize: 16 }
      }
    });
    return;
  }

  statusChartInstance.setOption({
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(30, 41, 59, 0.95)',
      borderColor: '#334155',
      textStyle: { color: '#fff' },
      formatter: '{b}: {c}单 ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left',
      top: 'middle',
      textStyle: { color: '#475569', fontWeight: 600 }
    },
    series: [
      {
        name: '订单状态',
        type: 'pie',
        radius: ['40%', '70%'], // 环形图
        center: ['60%', '50%'],
        avoidLabelOverlap: false,
        itemStyle: {
          borderRadius: 8,
          borderColor: '#fff',
          borderWidth: 2
        },
        label: {
          show: true,
          formatter: '{b}\n{c}单 ({d}%)'
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 16,
            fontWeight: 'bold'
          }
        },
        data: pieData
      }
    ],
    color: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#64748b']
  });
};

// 加载订单时间分布数据
const loadHourData = async () => {
  try {
    const data = await getOrderHourDistribution();
    if (!data || !Array.isArray(data)) {
      ElMessage.error('订单时间分布数据格式错误');
      return;
    }
    renderHourChart(data || []);
  } catch (e) {
    ElMessage.error('加载订单时间分布数据失败');
    console.error('加载订单时间分布数据错误:', e);
  }
};

// 渲染下单时间分布折线图
const renderHourChart = (data) => {
  if (!hourChartRef.value) return;

  if (!hourChartInstance) {
    hourChartInstance = echarts.init(hourChartRef.value);
  }

  // 确保24小时数据完整
  const hourData = Array(24).fill(0);
  data.forEach((item) => {
    const hour = Number(item.hour || item.hourNum || 0);
    if (hour >= 0 && hour < 24) {
      hourData[hour] = Number(item.count || 0);
    }
  });

  const hours = Array.from({ length: 24 }, (_, i) => `${i}:00`);
  
  // 检查是否有数据
  const hasData = hourData.some(count => count > 0);
  if (!hasData) {
    hourChartInstance.setOption({
      title: {
        text: '暂无数据',
        left: 'center',
        top: 'center',
        textStyle: { color: '#64748b', fontSize: 16 }
      }
    });
    return;
  }

  hourChartInstance.setOption({
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(30, 41, 59, 0.95)',
      borderColor: '#334155',
      textStyle: { color: '#fff' },
      formatter: (params) => {
        return `${params[0].axisValue}<br/>${params[0].marker}订单量: ${params[0].value}单`;
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: hours,
      axisLine: { lineStyle: { color: '#cbd5e1' } },
      axisLabel: { color: '#64748b', rotate: 45 }
    },
    yAxis: {
      type: 'value',
      name: '订单量',
      axisLine: { lineStyle: { color: '#cbd5e1' } },
      axisLabel: { color: '#64748b', formatter: '{value} 单' },
      splitLine: { lineStyle: { color: '#f1f5f9' } }
    },
    series: [
      {
        name: '订单量',
        type: 'line',
        data: hourData,
        smooth: true,
        lineStyle: { color: '#8b5cf6', width: 3 },
        itemStyle: { color: '#8b5cf6' },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(139, 92, 246, 0.3)' },
            { offset: 1, color: 'rgba(139, 92, 246, 0.1)' }
          ])
        },
        markPoint: {
          data: [
            { type: 'max', name: '最大值' },
            { type: 'min', name: '最小值' }
          ]
        }
      }
    ]
  });
};

const resizeCharts = () => {
  if (trendChartInstance) trendChartInstance.resize();
  if (statusChartInstance) statusChartInstance.resize();
  if (hourChartInstance) hourChartInstance.resize();
};

onMounted(async () => {
  await nextTick();
  // 检查是否已登录
  const token = localStorage.getItem('token');
  const role = localStorage.getItem('role');
  
  if (!token || role !== 'employee') {
    ElMessage.error('请先登录员工账号');
    return;
  }
  
  // 加载所有图表数据
  try {
    await Promise.all([
      loadTrendData(),
      loadStatusData(),
      loadHourData()
    ]);
  } catch (e) {
    console.error('加载图表数据失败:', e);
  }
  window.addEventListener('resize', resizeCharts);
});

onBeforeUnmount(() => {
  if (trendChartInstance) {
    trendChartInstance.dispose();
  }
  if (statusChartInstance) {
    statusChartInstance.dispose();
  }
  if (hourChartInstance) {
    hourChartInstance.dispose();
  }
  window.removeEventListener('resize', resizeCharts);
});
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
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-content {
  color: #fff;
  flex: 1;
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

.header-actions {
  display: flex;
  gap: 12px;
}

.charts-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-bottom: 24px;
}

.chart-card {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

.chart-card.full-width {
  grid-column: 1 / -1;
}

.chart-title {
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 2px solid #f1f5f9;
}

.chart-title h3 {
  margin: 0 0 8px 0;
  font-size: 18px;
  font-weight: 700;
  color: #1e293b;
}

.chart-title p {
  margin: 0;
  font-size: 14px;
  color: #64748b;
}

.chart-container {
  padding: 10px 0;
}

.chart {
  width: 100%;
  height: 400px;
  min-height: 350px;
}

@media (max-width: 1200px) {
  .charts-grid {
    grid-template-columns: 1fr;
  }
  
  .chart-card.full-width {
    grid-column: 1;
  }
}
</style>

