import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: () => import('@/views/Home.vue')
  },
  {
    path: '/resources',
    name: 'Resources',
    component: () => import('@/views/Resources.vue')
  },
  {
    path: '/resources/:id',
    name: 'ResourceDetail',
    component: () => import('@/views/ResourceDetail.vue')
  },
  {
    path: '/upload',
    name: 'Upload',
    component: () => import('@/views/Upload.vue')
  },
  {
    path: '/categories',
    name: 'Categories',
    component: () => import('@/views/Categories.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
