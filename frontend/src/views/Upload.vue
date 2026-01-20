<template>
  <div class="upload">
    <div class="page-header">
      <h2 class="page-title">上传资源</h2>
    </div>

    <el-row :gutter="24">
      <el-col :xs="24" :lg="16">
        <el-card shadow="never" class="upload-card">
          <el-upload
            ref="uploadRef"
            v-model:file-list="fileList"
            class="upload-demo"
            drag
            :action="uploadUrl"
            :on-preview="handlePreview"
            :on-remove="handleRemove"
            :on-change="handleChange"
            :before-upload="beforeUpload"
            :on-progress="handleProgress"
            :on-success="handleSuccess"
            :on-error="handleError"
            :auto-upload="false"
            multiple
          >
            <div class="upload-content">
              <el-icon class="upload-icon"><UploadFilled /></el-icon>
              <div class="upload-text">
                <p class="text-primary">拖放文件到此处或点击上传</p>
                <p class="text-secondary">
                  支持单个或批量上传，严禁上传公司数据或其他敏感信息
                </p>
              </div>
              <div class="upload-tips">
                <el-tag size="small" type="info">支持格式: PDF, DOC, XLS, PPT, IMG, ZIP</el-tag>
                <el-tag size="small" type="info">最大限制: 500MB</el-tag>
              </div>
            </div>
          </el-upload>

          <div v-if="fileList.length > 0" class="upload-actions">
            <el-button @click="clearFiles">清空列表</el-button>
            <el-button type="primary" :loading="uploading" @click="submitUpload">
              {{ uploading ? '上传中...' : '开始上传' }}
            </el-button>
          </div>
        </el-card>

        <el-card v-if="fileList.length > 0" shadow="never" class="file-list-card">
          <template #header>
            <div class="card-header">
              <span class="card-title">待上传文件 ({{ fileList.length }})</span>
              <el-tag type="info">{{ formatTotalSize() }}</el-tag>
            </div>
          </template>
          <div class="file-list">
            <div v-for="file in fileList" :key="file.uid" class="file-item">
              <div class="file-icon">
                <el-icon :size="32" :color="getFileColor(file.name)">
                  <component :is="getFileIcon(file.name)" />
                </el-icon>
              </div>
              <div class="file-info">
                <div class="file-name">{{ file.name }}</div>
                <div class="file-meta">
                  <span>{{ formatFileSize(file.size) }}</span>
                  <el-tag v-if="file.status === 'success'" type="success" size="small">
                    上传成功
                  </el-tag>
                  <el-tag v-else-if="file.status === 'uploading'" type="primary" size="small">
                    上传中
                  </el-tag>
                  <el-tag v-else-if="file.status === 'error'" type="danger" size="small">
                    上传失败
                  </el-tag>
                </div>
                <div v-if="file.status === 'uploading'" class="file-progress">
                  <el-progress
                    :percentage="file.percentage || 0"
                    :stroke-width="6"
                    :show-text="false"
                  />
                </div>
              </div>
              <div class="file-actions">
                <el-button
                  :icon="Delete"
                  circle
                  size="small"
                  type="danger"
                  @click="handleRemove(file)"
                />
              </div>
            </div>
          </div>
        </el-card>
      </el-col>

      <el-col :xs="24" :lg="8">
        <el-card shadow="never" class="settings-card">
          <template #header>
            <span class="card-title">上传设置</span>
          </template>

          <el-form label-position="top">
            <el-form-item label="选择分类">
              <el-select v-model="uploadForm.category" placeholder="请选择分类" style="width: 100%">
                <el-option label="文档" value="document" />
                <el-option label="图片" value="image" />
                <el-option label="视频" value="video" />
                <el-option label="音频" value="audio" />
                <el-option label="其他" value="other" />
              </el-select>
            </el-form-item>

            <el-form-item label="添加标签">
              <el-select
                v-model="uploadForm.tags"
                multiple
                filterable
                allow-create
                placeholder="请输入标签"
                style="width: 100%"
              >
                <el-option label="工作" value="work" />
                <el-option label="个人" value="personal" />
                <el-option label="项目" value="project" />
                <el-option label="学习" value="study" />
              </el-select>
            </el-form-item>

            <el-form-item label="资源描述">
              <el-input
                v-model="uploadForm.description"
                type="textarea"
                :rows="4"
                placeholder="请输入资源描述"
              />
            </el-form-item>

            <el-form-item label="访问权限">
              <el-radio-group v-model="uploadForm.permission">
                <el-radio label="private">私有</el-radio>
                <el-radio label="public">公开</el-radio>
                <el-radio label="link">链接访问</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-form>
        </el-card>

        <el-card shadow="never" class="stats-card">
          <template #header>
            <span class="card-title">存储空间</span>
          </template>

          <div class="storage-info">
            <div class="storage-header">
              <span class="storage-label">已使用</span>
              <span class="storage-value">2.3 GB / 10 GB</span>
            </div>
            <el-progress :percentage="23" :stroke-width="12" :show-text="false" />
            <div class="storage-footer">
              <span>还剩 7.7 GB 可用空间</span>
              <el-button type="primary" link>扩容</el-button>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { UploadInstance, UploadUserFile, UploadProps } from 'element-plus'
import {
  UploadFilled,
  Upload,
  Document,
  Picture,
  VideoCamera,
  Headset,
  Folder,
  Delete,
  Files
} from '@element-plus/icons-vue'

const uploadRef = ref<UploadInstance>()
const fileList = ref<UploadUserFile[]>([])
const uploading = ref(false)
const uploadUrl = '/api/upload'

const uploadForm = reactive({
  category: '',
  tags: [],
  description: '',
  permission: 'private'
})

const handlePreview: UploadProps['onPreview'] = (uploadFile) => {
  console.log(uploadFile)
}

const handleRemove: UploadProps['onRemove'] = (file) => {
  const index = fileList.value.indexOf(file)
  if (index > -1) {
    fileList.value.splice(index, 1)
  }
}

const handleChange: UploadProps['onChange'] = (uploadFile, uploadFiles) => {
  fileList.value = uploadFiles
}

const beforeUpload: UploadProps['beforeUpload'] = (file) => {
  const isLt500M = file.size / 1024 / 1024 < 500
  if (!isLt500M) {
    ElMessage.error('上传文件大小不能超过 500MB!')
    return false
  }
  return true
}

const handleProgress: UploadProps['onProgress'] = (evt, uploadFile) => {
  uploadFile.percentage = Math.floor((evt.loaded / evt.total) * 100)
}

const handleSuccess: UploadProps['onSuccess'] = (response, uploadFile) => {
  ElMessage.success(`${uploadFile.name} 上传成功`)
  uploadFile.status = 'success'
}

const handleError: UploadProps['onError'] = (error, uploadFile) => {
  ElMessage.error(`${uploadFile.name} 上传失败`)
  uploadFile.status = 'error'
}

const submitUpload = () => {
  if (fileList.value.length === 0) {
    ElMessage.warning('请先选择要上传的文件')
    return
  }

  uploading.value = true
  uploadRef.value?.submit()
}

const clearFiles = () => {
  ElMessageBox.confirm('确定要清空所有文件吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      fileList.value = []
      ElMessage.success('已清空文件列表')
    })
    .catch(() => {})
}

const formatFileSize = (size?: number) => {
  if (!size) return '0 B'
  const units = ['B', 'KB', 'MB', 'GB']
  let index = 0
  let fileSize = size

  while (fileSize >= 1024 && index < units.length - 1) {
    fileSize /= 1024
    index++
  }

  return `${fileSize.toFixed(1)} ${units[index]}`
}

const formatTotalSize = () => {
  const total = fileList.value.reduce((sum, file) => sum + (file.size || 0), 0)
  return formatFileSize(total)
}

const getFileIcon = (fileName: string) => {
  const ext = fileName.split('.').pop()?.toLowerCase()
  const iconMap: Record<string, any> = {
    pdf: Document,
    doc: Document,
    docx: Document,
    xls: Document,
    xlsx: Document,
    ppt: Document,
    pptx: Document,
    txt: Document,
    jpg: Picture,
    jpeg: Picture,
    png: Picture,
    gif: Picture,
    svg: Picture,
    webp: Picture,
    mp4: VideoCamera,
    avi: VideoCamera,
    mkv: VideoCamera,
    mov: VideoCamera,
    mp3: Headset,
    wav: Headset,
    flac: Headset,
    zip: Folder,
    rar: Folder,
    '7z': Folder
  }
  return iconMap[ext || ''] || Files
}

const getFileColor = (fileName: string) => {
  const ext = fileName.split('.').pop()?.toLowerCase()
  const colorMap: Record<string, string> = {
    pdf: '#DC2626',
    doc: '#0891B2',
    docx: '#0891B2',
    xls: '#059669',
    xlsx: '#059669',
    ppt: '#fa709a',
    pptx: '#fa709a',
    jpg: '#ffd89b',
    jpeg: '#ffd89b',
    png: '#ffd89b',
    gif: '#ffd89b',
    mp4: '#667eea',
    mp3: '#f093fb',
    zip: '#64748B',
    rar: '#64748B'
  }
  return colorMap[ext || ''] || '#64748B'
}
</script>

<style scoped>
.upload {
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
  margin-bottom: 24px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #020617;
  margin: 0;
}

.upload-card {
  margin-bottom: 24px;
  border-radius: 12px;
}

.upload-demo {
  width: 100%;
}

.upload-demo :deep(.el-upload-dragger) {
  width: 100%;
  height: auto;
  min-height: 300px;
  padding: 48px 24px;
  border: 2px dashed #d9d9d9;
  border-radius: 12px;
  background: linear-gradient(135deg, #F8FAFC 0%, #c3cfe2 100%);
  transition: all 0.3s ease;
}

.upload-demo :deep(.el-upload-dragger:hover) {
  border-color: #667eea;
  background: linear-gradient(135deg, #667eea15 0%, #764ba215 100%);
}

.upload-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24px;
}

.upload-icon {
  font-size: 80px;
  color: #667eea;
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.upload-text {
  text-align: center;
}

.text-primary {
  font-size: 18px;
  font-weight: 600;
  color: #020617;
  margin: 0 0 8px 0;
}

.text-secondary {
  font-size: 14px;
  color: #64748B;
  margin: 0;
}

.upload-tips {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
  justify-content: center;
}

.upload-actions {
  display: flex;
  justify-content: space-between;
  margin-top: 24px;
  padding-top: 24px;
  border-top: 1px solid #f0f0f0;
}

.file-list-card {
  border-radius: 12px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #020617;
}

.file-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.file-item {
  display: flex;
  align-items: flex-start;
  gap: 16px;
  padding: 16px;
  border-radius: 8px;
  background: #F8FAFC;
  transition: all 0.3s ease;
}

.file-item:hover {
  background: white;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.file-icon {
  width: 56px;
  height: 56px;
  border-radius: 8px;
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  flex-shrink: 0;
}

.file-info {
  flex: 1;
  min-width: 0;
}

.file-name {
  font-size: 14px;
  font-weight: 500;
  color: #020617;
  margin-bottom: 4px;
  word-break: break-all;
}

.file-meta {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 12px;
  color: #64748B;
}

.file-progress {
  margin-top: 8px;
}

.file-actions {
  flex-shrink: 0;
}

.settings-card,
.stats-card {
  margin-bottom: 24px;
  border-radius: 12px;
}

.storage-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.storage-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.storage-label {
  font-size: 14px;
  color: #64748B;
}

.storage-value {
  font-size: 16px;
  font-weight: 600;
  color: #020617;
}

.storage-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  color: #64748B;
}

@media (max-width: 992px) {
  .upload-demo :deep(.el-upload-dragger) {
    min-height: 200px;
    padding: 32px 16px;
  }

  .upload-icon {
    font-size: 60px;
  }

  .text-primary {
    font-size: 16px;
  }
}
</style>
