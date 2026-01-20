<template>
  <aside class="app-sidebar" :class="{ collapsed: isCollapsed }">
    <div class="sidebar-header">
      <el-button
        :icon="isCollapsed ? Expand : Fold"
        circle
        @click="toggleCollapse"
        class="collapse-btn"
      />
    </div>

    <el-menu
      :default-active="activeMenu"
      :collapse="isCollapsed"
      :collapse-transition="false"
      class="sidebar-menu"
      router
    >
      <el-menu-item index="/">
        <el-icon><HomeFilled /></el-icon>
        <template #title>首页</template>
      </el-menu-item>

      <el-menu-item index="/resources">
        <el-icon><Files /></el-icon>
        <template #title>资源列表</template>
      </el-menu-item>

      <el-menu-item index="/upload">
        <el-icon><UploadFilled /></el-icon>
        <template #title>上传资源</template>
      </el-menu-item>

      <el-menu-item index="/categories">
        <el-icon><Grid /></el-icon>
        <template #title>分类管理</template>
      </el-menu-item>
    </el-menu>
  </aside>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  Fold,
  Expand,
  HomeFilled,
  Files,
  UploadFilled,
  Grid
} from '@element-plus/icons-vue'

const route = useRoute()
const isCollapsed = ref(false)

const activeMenu = computed(() => route.path)

const toggleCollapse = () => {
  isCollapsed.value = !isCollapsed.value
}
</script>

<style scoped>
.app-sidebar {
  width: 240px;
  height: calc(100vh - 64px);
  background: #FFFFFF;
  border-right: 1px solid #E2E8F0;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  overflow-y: auto;
  position: sticky;
  top: 64px;
}

.app-sidebar.collapsed {
  width: 64px;
}

.sidebar-header {
  padding: 16px;
  display: flex;
  justify-content: center;
}

.collapse-btn {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  color: #64748B;
}

.collapse-btn:hover {
  transform: rotate(180deg);
  color: #0369A1;
}

.sidebar-menu {
  border: none;
  padding: 8px 0;
}

.sidebar-menu:not(.el-menu--collapse) {
  width: 240px;
}

.sidebar-menu :deep(.el-menu-item) {
  margin: 2px 12px;
  border-radius: 6px;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  color: #334155;
  height: 40px;
  line-height: 40px;
}

.sidebar-menu :deep(.el-menu-item:hover) {
  background: #F1F5F9;
  transform: translateX(2px);
  color: #0369A1;
}

.sidebar-menu :deep(.el-menu-item.is-active) {
  background: #E0F2FE;
  color: #0369A1;
  font-weight: 600;
}

.app-sidebar::-webkit-scrollbar {
  width: 6px;
}

.app-sidebar::-webkit-scrollbar-track {
  background: #F1F5F9;
}

.app-sidebar::-webkit-scrollbar-thumb {
  background: #E2E8F0;
  border-radius: 3px;
  transition: background 0.2s ease;
}

.app-sidebar::-webkit-scrollbar-thumb:hover {
  background: #94A3B8;
}
</style>
