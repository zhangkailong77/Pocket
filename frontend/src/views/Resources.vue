<template>
  <div class="resources">
    <div class="page-header">
      <h2 class="page-title">资源列表</h2>
      <div class="header-actions">
        <el-button :icon="Upload" type="primary" @click="$router.push('/upload')">
          上传资源
        </el-button>
      </div>
    </div>

    <el-card shadow="never" class="filter-card">
      <el-row :gutter="16" class="filter-row">
        <el-col :xs="24" :sm="8" :md="6">
          <el-input
            v-model="searchQuery"
            placeholder="搜索资源..."
            :prefix-icon="Search"
            clearable
          />
        </el-col>
        <el-col :xs="24" :sm="8" :md="4">
          <el-select v-model="selectedCategory" placeholder="全部分类" clearable>
            <el-option label="全部分类" value="" />
            <el-option label="文档" value="document" />
            <el-option label="图片" value="image" />
            <el-option label="视频" value="video" />
            <el-option label="音频" value="audio" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="8" :md="4">
          <el-select v-model="sortBy" placeholder="排序方式">
            <el-option label="最新" value="date" />
            <el-option label="名称" value="name" />
            <el-option label="大小" value="size" />
          </el-select>
        </el-col>
        <el-col :xs="24" :sm="24" :md="6">
          <div class="view-toggle">
            <el-radio-group v-model="viewMode">
              <el-radio-button label="grid">
                <el-icon><Grid /></el-icon>
              </el-radio-button>
              <el-radio-button label="list">
                <el-icon><List /></el-icon>
              </el-radio-button>
            </el-radio-group>
            <el-button :icon="Filter" circle />
          </div>
        </el-col>
      </el-row>
    </el-card>

    <div v-if="viewMode === 'grid'" class="resources-grid">
      <el-card
        v-for="resource in filteredResources"
        :key="resource.id"
        class="resource-card"
        shadow="hover"
        @click="viewResource(resource.id)"
      >
        <div class="resource-preview" :style="{ background: resource.color + '20' }">
          <el-icon :size="64" :color="resource.color">
            <component :is="resource.icon" />
          </el-icon>
        </div>
        <div class="resource-content">
          <div class="resource-name">{{ resource.name }}</div>
          <div class="resource-meta">
            <span>{{ resource.size }}</span>
            <span>{{ resource.date }}</span>
          </div>
        </div>
        <div class="resource-actions">
          <el-button
            :icon="Star"
            circle
            size="small"
            :type="resource.isFavorite ? 'warning' : ''"
            @click.stop="toggleFavorite(resource.id)"
          />
          <el-button :icon="MoreFilled" circle size="small" @click.stop="" />
        </div>
      </el-card>
    </div>

    <el-card v-else shadow="never" class="resources-list">
      <el-table :data="filteredResources" style="width: 100%">
        <el-table-column type="selection" width="55" />
        <el-table-column label="名称" min-width="250">
          <template #default="{ row }">
            <div class="table-resource-name">
              <div
                class="resource-icon-small"
                :style="{ background: row.color + '20' }"
              >
                <el-icon :size="24" :color="row.color">
                  <component :is="row.icon" />
                </el-icon>
              </div>
              <span>{{ row.name }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="category" label="分类" width="120" />
        <el-table-column prop="size" label="大小" width="100" />
        <el-table-column prop="date" label="上传日期" width="120" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button
              type="primary"
              link
              :icon="View"
              @click="viewResource(row.id)"
            >
              查看
            </el-button>
            <el-button type="primary" link :icon="Download">
              下载
            </el-button>
            <el-button type="danger" link :icon="Delete">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <div v-if="filteredResources.length === 0" class="empty-state">
      <el-empty description="暂无资源">
        <el-button type="primary" :icon="Upload" @click="$router.push('/upload')">
          上传资源
        </el-button>
      </el-empty>
    </div>

    <div v-if="filteredResources.length > 0" class="pagination-wrapper">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[12, 24, 48, 96]"
        :total="totalResources"
        layout="total, sizes, prev, pager, next, jumper"
        background
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import {
  Search,
  Upload,
  Grid,
  List,
  Filter,
  Star,
  MoreFilled,
  Document,
  Picture,
  VideoCamera,
  Headset,
  Folder,
  View,
  Download,
  Delete
} from '@element-plus/icons-vue'

const router = useRouter()

const searchQuery = ref('')
const selectedCategory = ref('')
const sortBy = ref('date')
const viewMode = ref<'grid' | 'list'>('grid')
const currentPage = ref(1)
const pageSize = ref(12)
const totalResources = ref(36)

const resources = ref([
  {
    id: 1,
    name: '项目需求文档.pdf',
    category: 'document',
    size: '2.3 MB',
    date: '2024-01-20',
    icon: Document,
    color: '#DC2626',
    isFavorite: true
  },
  {
    id: 2,
    name: 'UI设计稿.fig',
    category: 'image',
    size: '15.6 MB',
    date: '2024-01-19',
    icon: Picture,
    color: '#0891B2',
    isFavorite: false
  },
  {
    id: 3,
    name: '产品演示.mp4',
    category: 'video',
    size: '256 MB',
    date: '2024-01-18',
    icon: VideoCamera,
    color: '#059669',
    isFavorite: true
  },
  {
    id: 4,
    name: '背景音乐.mp3',
    category: 'audio',
    size: '8.5 MB',
    date: '2024-01-17',
    icon: Headset,
    color: '#fa709a',
    isFavorite: false
  },
  {
    id: 5,
    name: '项目资源包',
    category: 'folder',
    size: '1.2 GB',
    date: '2024-01-16',
    icon: Folder,
    color: '#667eea',
    isFavorite: false
  },
  {
    id: 6,
    name: '技术方案.docx',
    category: 'document',
    size: '1.8 MB',
    date: '2024-01-15',
    icon: Document,
    color: '#DC2626',
    isFavorite: false
  },
  {
    id: 7,
    name: 'Logo设计.png',
    category: 'image',
    size: '3.2 MB',
    date: '2024-01-14',
    icon: Picture,
    color: '#0891B2',
    isFavorite: true
  },
  {
    id: 8,
    name: '教程视频.mp4',
    category: 'video',
    size: '512 MB',
    date: '2024-01-13',
    icon: VideoCamera,
    color: '#059669',
    isFavorite: false
  },
  {
    id: 9,
    name: '会议记录.pdf',
    category: 'document',
    size: '890 KB',
    date: '2024-01-12',
    icon: Document,
    color: '#DC2626',
    isFavorite: false
  }
])

const filteredResources = computed(() => {
  let filtered = resources.value

  if (searchQuery.value) {
    filtered = filtered.filter((r) =>
      r.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  }

  if (selectedCategory.value) {
    filtered = filtered.filter((r) => r.category === selectedCategory.value)
  }

  return filtered
})

const viewResource = (id: number) => {
  router.push(`/resources/${id}`)
}

const toggleFavorite = (id: number) => {
  const resource = resources.value.find((r) => r.id === id)
  if (resource) {
    resource.isFavorite = !resource.isFavorite
  }
}
</script>

<style scoped>
.resources {
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

.filter-card {
  margin-bottom: 24px;
  border-radius: 12px;
}

.filter-row {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
}

.filter-row > * {
  margin-bottom: 16px;
}

.view-toggle {
  display: flex;
  align-items: center;
  gap: 12px;
  justify-content: flex-end;
}

.resources-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  margin-bottom: 24px;
}

.resource-card {
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  border: none;
  overflow: hidden;
}

.resource-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.resource-preview {
  height: 160px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px 12px 0 0;
  position: relative;
  overflow: hidden;
}

.resource-preview::before {
  content: '';
  position: absolute;
  top: -50%;
  left: -50%;
  width: 200%;
  height: 200%;
  background: radial-gradient(circle, rgba(255, 255, 255, 0.3) 1px, transparent 1px);
  background-size: 20px 20px;
  opacity: 0.5;
}

.resource-content {
  padding: 16px;
}

.resource-name {
  font-size: 16px;
  font-weight: 600;
  color: #020617;
  margin-bottom: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.resource-meta {
  display: flex;
  justify-content: space-between;
  font-size: 12px;
  color: #64748B;
}

.resource-actions {
  display: flex;
  gap: 8px;
  padding: 12px 16px;
  border-top: 1px solid #f0f0f0;
  justify-content: flex-end;
}

.resources-list {
  border-radius: 12px;
  margin-bottom: 24px;
}

.table-resource-name {
  display: flex;
  align-items: center;
  gap: 12px;
}

.resource-icon-small {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-state {
  margin: 48px 0;
}

.pagination-wrapper {
  display: flex;
  justify-content: center;
  padding: 24px 0;
}

@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
  }

  .header-actions {
    width: 100%;
  }

  .header-actions .el-button {
    width: 100%;
  }

  .resources-grid {
    grid-template-columns: 1fr;
  }

  .view-toggle {
    width: 100%;
    justify-content: space-between;
  }
}
</style>
