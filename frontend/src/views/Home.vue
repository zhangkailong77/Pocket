<template>
  <div class="home">
    <el-row :gutter="24" class="hero-section">
      <el-col :span="24">
        <div class="hero-banner">
          <div class="hero-content">
            <h1 class="hero-title">Pocket 公司资源库</h1>
            <p class="hero-subtitle">产品参数、课程资源、视频教程 - 一站式管理</p>
            <div class="hero-actions">
              <el-button class="hero-primary-btn" size="large" :icon="Upload" @click="$router.push('/upload')">
                上传资源
              </el-button>
              <el-button class="hero-secondary-btn" size="large" :icon="Files" @click="$router.push('/resources')">
                浏览资源
              </el-button>
            </div>
          </div>
          <div class="hero-decoration">
            <el-icon :size="200" color="rgba(255, 255, 255, 0.15)">
              <FolderOpened />
            </el-icon>
          </div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="24" class="stats-section">
      <el-col :xs="24" :sm="12" :md="6" v-for="stat in stats" :key="stat.title">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" :style="{ background: stat.color }">
              <el-icon :size="32" color="white">
                <component :is="stat.icon" />
              </el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stat.value }}</div>
              <div class="stat-title">{{ stat.title }}</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="24" class="quick-actions-section">
      <el-col :span="24">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span class="card-title">快速操作</span>
            </div>
          </template>
          <div class="quick-actions">
            <div
              v-for="action in quickActions"
              :key="action.title"
              class="quick-action-item"
              @click="action.handler"
            >
              <div class="action-icon" :style="{ background: action.color }">
                <el-icon :size="24" color="white">
                  <component :is="action.icon" />
                </el-icon>
              </div>
              <span class="action-title">{{ action.title }}</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="24" class="recent-section">
      <el-col :span="24">
        <el-card shadow="hover">
          <template #header>
            <div class="card-header">
              <span class="card-title">最近资源</span>
              <el-button type="primary" link @click="$router.push('/resources')">
                查看全部
              </el-button>
            </div>
          </template>
          <el-empty v-if="recentResources.length === 0" description="暂无资源" />
          <div v-else class="recent-resources">
            <div
              v-for="resource in recentResources"
              :key="resource.id"
              class="resource-item"
            >
              <div class="resource-icon">
                <el-icon :size="40" :color="resource.color">
                  <component :is="resource.icon" />
                </el-icon>
              </div>
              <div class="resource-info">
                <div class="resource-name">{{ resource.name }}</div>
                <div class="resource-meta">
                  <span>{{ resource.size }}</span>
                  <span>{{ resource.date }}</span>
                </div>
              </div>
              <el-button circle :icon="MoreFilled" />
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  Upload,
  Files,
  FolderOpened,
  Document,
  Picture,
  VideoCamera,
  Folder,
  Star,
  Delete,
  MoreFilled
} from '@element-plus/icons-vue'

const router = useRouter()

const stats = ref([
  {
    title: '总资源',
    value: '1,234',
    icon: Files,
    color: '#0369A1'
  },
  {
    title: '文档',
    value: '456',
    icon: Document,
    color: '#DC2626'
  },
  {
    title: '图片',
    value: '789',
    icon: Picture,
    color: '#0891B2'
  },
  {
    title: '视频',
    value: '123',
    icon: VideoCamera,
    color: '#059669'
  }
])

const quickActions = ref([
  {
    title: '上传文件',
    icon: Upload,
    color: '#0369A1',
    handler: () => router.push('/upload')
  },
  {
    title: '浏览资源',
    icon: Files,
    color: '#DC2626',
    handler: () => router.push('/resources')
  },
  {
    title: '分类管理',
    icon: Star,
    color: '#0891B2',
    handler: () => router.push('/categories')
  }
])

const recentResources = ref([
  {
    id: 1,
    name: '项目文档.pdf',
    size: '2.3 MB',
    date: '2024-01-20',
    icon: Document,
    color: '#DC2626'
  },
  {
    id: 2,
    name: '设计稿.png',
    size: '4.5 MB',
    date: '2024-01-19',
    icon: Picture,
    color: '#0891B2'
  },
  {
    id: 3,
    name: '演示视频.mp4',
    size: '125 MB',
    date: '2024-01-18',
    icon: VideoCamera,
    color: '#059669'
  }
])
</script>

<style scoped>
.home {
  animation: fadeIn 0.5s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.hero-section {
  margin-bottom: 24px;
}

.hero-banner {
  background: #0369A1;
  border-radius: 16px;
  padding: 48px;
  color: #FFFFFF;
  display: flex;
  justify-content: space-between;
  align-items: center;
  box-shadow: 0 4px 12px rgba(3, 105, 161, 0.2);
  position: relative;
  overflow: hidden;
}

.hero-banner::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.08) 1px, transparent 1px);
  background-size: 50px 50px;
  animation: moveBackground 20s linear infinite;
}

@keyframes moveBackground {
  0% {
    transform: translate(0, 0);
  }
  100% {
    transform: translate(50px, 50px);
  }
}

.hero-content {
  z-index: 1;
  flex: 1;
}

.hero-title {
  font-size: 48px;
  font-weight: 700;
  margin-bottom: 16px;
  color: #FFFFFF;
}

.hero-subtitle {
  font-size: 20px;
  opacity: 0.95;
  margin-bottom: 32px;
  font-weight: 400;
  color: #F0F9FF;
}

.hero-actions {
  display: flex;
  gap: 16px;
}

.hero-actions .el-button {
  padding: 14px 36px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 8px;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.hero-primary-btn {
  background: #FFFFFF !important;
  border-color: #FFFFFF !important;
  color: #0369A1 !important;
}

.hero-primary-btn:hover {
  background: #F0F9FF !important;
  border-color: #E0F2FE !important;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.hero-secondary-btn {
  background: transparent !important;
  border-color: #FFFFFF !important;
  color: #FFFFFF !important;
}

.hero-secondary-btn:hover {
  background: rgba(255, 255, 255, 0.15) !important;
  border-color: #FFFFFF !important;
  transform: translateY(-2px);
}

.hero-decoration {
  z-index: 1;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

.stats-section {
  margin-bottom: 24px;
}

.stat-card {
  margin-bottom: 24px;
  border-radius: 12px;
  border: none;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-8px);
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.stat-icon {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 32px;
  font-weight: 700;
  color: #020617;
  margin-bottom: 4px;
}

.stat-title {
  font-size: 14px;
  color: #64748B;
}

.quick-actions-section {
  margin-bottom: 24px;
}

.quick-actions {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 24px;
}

.quick-action-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 16px;
  padding: 24px;
  border-radius: 12px;
  background: #F8FAFC;
  cursor: pointer;
  transition: all 0.3s ease;
}

.quick-action-item:hover {
  background: white;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-4px);
}

.action-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.action-title {
  font-size: 16px;
  font-weight: 500;
  color: #020617;
}

.recent-section {
  margin-bottom: 24px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: #020617;
}

.recent-resources {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.resource-item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px;
  border-radius: 8px;
  background: #F8FAFC;
  transition: all 0.3s ease;
  cursor: pointer;
}

.resource-item:hover {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transform: translateX(4px);
}

.resource-icon {
  width: 56px;
  height: 56px;
  border-radius: 8px;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.resource-info {
  flex: 1;
}

.resource-name {
  font-size: 16px;
  font-weight: 500;
  color: #020617;
  margin-bottom: 4px;
}

.resource-meta {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: #64748B;
}

@media (max-width: 768px) {
  .hero-banner {
    padding: 32px 24px;
  }

  .hero-title {
    font-size: 32px;
  }

  .hero-subtitle {
    font-size: 16px;
  }

  .hero-decoration {
    display: none;
  }

  .quick-actions {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
