<template>
  <div class="app-layout">
    <AppHeader />
    <div class="layout-container">
      <AppSidebar />
      <main class="main-content">
        <div class="content-wrapper">
          <router-view v-slot="{ Component }">
            <transition name="fade" mode="out-in">
              <component :is="Component" />
            </transition>
          </router-view>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import AppHeader from './AppHeader.vue'
import AppSidebar from './AppSidebar.vue'
</script>

<style scoped>
.app-layout {
  min-height: 100vh;
  background: #F8FAFC;
}

.layout-container {
  display: flex;
}

.main-content {
  flex: 1;
  margin-left: 0;
  overflow-x: hidden;
}

.content-wrapper {
  padding: 24px;
  min-height: calc(100vh - 64px);
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

@media (max-width: 768px) {
  .content-wrapper {
    padding: 16px;
  }
}
</style>
