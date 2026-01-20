<template>
  <div class="categories">
    <div class="page-header">
      <h2 class="page-title">分类管理</h2>
      <el-button type="primary" :icon="Plus" @click="openCreateDialog">
        新建分类
      </el-button>
    </div>

    <el-row :gutter="24" class="stats-row">
      <el-col :xs="12" :sm="6" v-for="stat in stats" :key="stat.label">
        <div class="stat-item">
          <div class="stat-value">{{ stat.value }}</div>
          <div class="stat-label">{{ stat.label }}</div>
        </div>
      </el-col>
    </el-row>

    <el-card shadow="never" class="categories-card">
      <div class="categories-grid">
        <div
          v-for="category in categories"
          :key="category.id"
          class="category-item"
          :class="{ 'is-dragging': draggingId === category.id }"
          draggable="true"
          @dragstart="handleDragStart(category.id)"
          @dragover.prevent
          @drop="handleDrop(category.id)"
        >
          <div class="category-header" :style="{ background: category.color }">
            <el-icon :size="32" color="white">
              <component :is="category.icon" />
            </el-icon>
            <div class="category-actions">
              <el-button
                :icon="Edit"
                circle
                size="small"
                type="primary"
                @click="openEditDialog(category)"
              />
              <el-button
                :icon="Delete"
                circle
                size="small"
                type="danger"
                @click="handleDelete(category)"
              />
            </div>
          </div>
          <div class="category-content">
            <div class="category-name">{{ category.name }}</div>
            <div class="category-meta">
              <el-tag size="small">{{ category.count }} 个资源</el-tag>
              <span class="category-date">{{ category.date }}</span>
            </div>
            <div class="category-progress">
              <el-progress
                :percentage="category.percentage"
                :stroke-width="6"
                :show-text="false"
                :color="category.color"
              />
            </div>
          </div>
        </div>

        <div
          class="category-item add-category"
          @click="openCreateDialog"
        >
          <div class="add-content">
            <el-icon :size="48" color="#64748B">
              <Plus />
            </el-icon>
            <span>添加新分类</span>
          </div>
        </div>
      </div>
    </el-card>

    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑分类' : '新建分类'"
      width="500px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" label-width="80px">
        <el-form-item label="分类名称">
          <el-input v-model="form.name" placeholder="请输入分类名称" />
        </el-form-item>

        <el-form-item label="选择图标">
          <div class="icon-selector">
            <div
              v-for="icon in availableIcons"
              :key="icon.name"
              class="icon-option"
              :class="{ active: form.icon === icon.component }"
              @click="form.icon = icon.component"
            >
              <el-icon :size="24">
                <component :is="icon.component" />
              </el-icon>
            </div>
          </div>
        </el-form-item>

        <el-form-item label="选择颜色">
          <div class="color-selector">
            <div
              v-for="color in availableColors"
              :key="color"
              class="color-option"
              :class="{ active: form.color === color }"
              :style="{ background: color }"
              @click="form.color = color"
            />
          </div>
        </el-form-item>

        <el-form-item label="分类描述">
          <el-input
            v-model="form.description"
            type="textarea"
            :rows="3"
            placeholder="请输入分类描述"
          />
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus,
  Edit,
  Delete,
  Document,
  Picture,
  VideoCamera,
  Headset,
  Folder,
  Files,
  Star,
  Share,
  Link
} from '@element-plus/icons-vue'

const dialogVisible = ref(false)
const isEdit = ref(false)
const draggingId = ref<number | null>(null)

const stats = ref([
  { label: '总分类', value: '8' },
  { label: '本月新增', value: '+3' },
  { label: '使用率', value: '85%' },
  { label: '资源数', value: '1,234' }
])

const categories = ref([
  {
    id: 1,
    name: '文档资料',
    icon: Document,
    color: '#DC2626',
    count: 456,
    percentage: 75,
    date: '2024-01-20'
  },
  {
    id: 2,
    name: '图片素材',
    icon: Picture,
    color: '#0891B2',
    count: 789,
    percentage: 90,
    date: '2024-01-19'
  },
  {
    id: 3,
    name: '视频教程',
    icon: VideoCamera,
    color: '#059669',
    percentage: 60,
    count: 123,
    date: '2024-01-18'
  },
  {
    id: 4,
    name: '音频文件',
    icon: Headset,
    color: '#fa709a',
    percentage: 45,
    count: 89,
    date: '2024-01-17'
  },
  {
    id: 5,
    name: '工作项目',
    icon: Folder,
    color: '#667eea',
    percentage: 80,
    count: 234,
    date: '2024-01-16'
  },
  {
    id: 6,
    name: '收藏夹',
    icon: Star,
    color: '#ffd89b',
    percentage: 55,
    count: 67,
    date: '2024-01-15'
  },
  {
    id: 7,
    name: '分享资源',
    icon: Share,
    color: '#a8edea',
    percentage: 35,
    count: 45,
    date: '2024-01-14'
  },
  {
    id: 8,
    name: '快捷链接',
    icon: Link,
    color: '#fed6e3',
    percentage: 25,
    count: 23,
    date: '2024-01-13'
  }
])

const form = reactive({
  id: 0,
  name: '',
  icon: Document,
  color: '#667eea',
  description: ''
})

const availableIcons = [
  { name: 'document', component: Document },
  { name: 'picture', component: Picture },
  { name: 'video', component: VideoCamera },
  { name: 'audio', component: Headset },
  { name: 'folder', component: Folder },
  { name: 'files', component: Files },
  { name: 'star', component: Star },
  { name: 'share', component: Share }
]

const availableColors = [
  '#667eea',
  '#764ba2',
  '#DC2626',
  '#0891B2',
  '#059669',
  '#fa709a',
  '#ffd89b',
  '#a8edea',
  '#fed6e3',
  '#c3cfe2'
]

const openCreateDialog = () => {
  isEdit.value = false
  form.id = 0
  form.name = ''
  form.icon = Document
  form.color = '#667eea'
  form.description = ''
  dialogVisible.value = true
}

const openEditDialog = (category: any) => {
  isEdit.value = true
  form.id = category.id
  form.name = category.name
  form.icon = category.icon
  form.color = category.color
  form.description = ''
  dialogVisible.value = true
}

const handleSubmit = () => {
  if (!form.name) {
    ElMessage.warning('请输入分类名称')
    return
  }

  if (isEdit.value) {
    const index = categories.value.findIndex((c) => c.id === form.id)
    if (index > -1) {
      categories.value[index] = {
        ...categories.value[index],
        name: form.name,
        icon: form.icon,
        color: form.color
      }
    }
    ElMessage.success('分类更新成功')
  } else {
    const newCategory = {
      id: Date.now(),
      name: form.name,
      icon: form.icon,
      color: form.color,
      count: 0,
      percentage: 0,
      date: new Date().toISOString().split('T')[0]
    }
    categories.value.push(newCategory)
    ElMessage.success('分类创建成功')
  }

  dialogVisible.value = false
}

const handleDelete = (category: any) => {
  ElMessageBox.confirm(`确定要删除分类"${category.name}"吗？`, '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = categories.value.findIndex((c) => c.id === category.id)
      if (index > -1) {
        categories.value.splice(index, 1)
      }
      ElMessage.success('删除成功')
    })
    .catch(() => {})
}

const handleDragStart = (id: number) => {
  draggingId.value = id
}

const handleDrop = (targetId: number) => {
  if (draggingId.value === null || draggingId.value === targetId) {
    return
  }

  const draggingIndex = categories.value.findIndex((c) => c.id === draggingId.value)
  const targetIndex = categories.value.findIndex((c) => c.id === targetId)

  if (draggingIndex > -1 && targetIndex > -1) {
    const [removed] = categories.value.splice(draggingIndex, 1)
    categories.value.splice(targetIndex, 0, removed)
  }

  draggingId.value = null
}
</script>

<style scoped>
.categories {
  animation: fadeIn 0.3s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #020617;
  margin: 0;
}

.stats-row {
  margin-bottom: 24px;
}

.stat-item {
  background: white;
  padding: 20px;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  margin-bottom: 16px;
  transition: all 0.3s ease;
}

.stat-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #020617;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #64748B;
}

.categories-card {
  border-radius: 12px;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
}

.category-item {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
  cursor: grab;
}

.category-item:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.category-item.is-dragging {
  opacity: 0.5;
}

.category-item:active {
  cursor: grabbing;
}

.category-header {
  height: 100px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  position: relative;
}

.category-header::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 1px, transparent 1px);
  background-size: 20px 20px;
  opacity: 0.3;
}

.category-actions {
  display: flex;
  gap: 8px;
  z-index: 1;
}

.category-actions .el-button {
  background: rgba(255, 255, 255, 0.2);
  border: none;
  color: white;
}

.category-content {
  padding: 20px;
}

.category-name {
  font-size: 18px;
  font-weight: 600;
  color: #020617;
  margin-bottom: 12px;
}

.category-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.category-date {
  font-size: 12px;
  color: #64748B;
}

.add-category {
  border: 2px dashed #d9d9d9;
  background: transparent;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 200px;
}

.add-category:hover {
  border-color: #667eea;
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
}

.add-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: #64748B;
  font-size: 16px;
}

.icon-selector {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
}

.icon-option {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  border: 2px solid #e4e7ed;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s ease;
  color: #606266;
}

.icon-option:hover {
  border-color: #667eea;
  background: #667eea15;
}

.icon-option.active {
  border-color: #667eea;
  background: #667eea;
  color: white;
}

.color-selector {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
}

.color-option {
  width: 48px;
  height: 48px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.color-option:hover {
  transform: scale(1.1);
}

.color-option.active {
  border-color: #020617;
  box-shadow: 0 0 0 2px white inset;
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .categories-grid {
    grid-template-columns: 1fr;
  }
}
</style>
