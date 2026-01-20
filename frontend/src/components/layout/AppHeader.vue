<template>
  <header class="app-header">
    <div class="header-left">
      <div class="logo">
        <el-icon :size="28" color="#ffffff">
          <FolderOpened />
        </el-icon>
        <span class="logo-text">Pocket 资源库</span>
      </div>
    </div>

    <div class="header-center">
      <el-input
        v-model="searchText"
        placeholder="搜索产品参数、课程资源、视频..."
        :prefix-icon="Search"
        class="search-input"
        clearable
      />
    </div>

    <div class="header-right">
      <!-- 右侧区域保留，可用于未来扩展 -->
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { Search, FolderOpened } from '@element-plus/icons-vue'

const searchText = ref('')
</script>

<style scoped>
.app-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
  padding: 0 24px;
  background: #FFFFFF;
  border-bottom: 1px solid #E2E8F0;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-left {
  display: flex;
  align-items: center;
  min-width: 200px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 12px;
  color: #0F172A;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.logo:hover {
  transform: scale(1.01);
}

.logo-text {
  font-size: 22px;
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #0F172A;
}

.header-center {
  flex: 1;
  max-width: 600px;
  margin: 0 24px;
}

.search-input {
  width: 100%;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 8px;
  background: #F8FAFC;
  border: 1px solid #E2E8F0;
  box-shadow: none;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

.search-input :deep(.el-input__wrapper:hover) {
  border-color: #94A3B8;
  background: #F8FAFC;
}

.search-input :deep(.el-input__wrapper.is-focus) {
  border-color: #0369A1;
  background: #FFFFFF;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 100px;
  justify-content: flex-end;
}

@media (max-width: 768px) {
  .app-header {
    padding: 0 16px;
  }

  .header-center {
    display: none;
  }

  .logo-text {
    font-size: 18px;
  }
}
</style>
