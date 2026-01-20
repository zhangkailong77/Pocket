# Pocket - 个人资源仓库

一个用于存储、管理和便捷访问各类资源的个人网站，支持预览和下载。

## 特性

- 📁 支持多种文件类型（文档、图片、视频、音频等）
- 👀 在线预览（PDF、图片、视频）
- 🏷️ 分类和标签管理
- 🔍 全文搜索
- ☁️ 本地 Docker 部署

## 技术栈

### 前端
- Vue 3 + TypeScript
- Vite
- Element Plus
- Pinia
- Vue Router

### 后端
- FastAPI
- SQLAlchemy
- MySQL 8.0
- Alembic

## 快速开始

### 使用 Docker Compose

1. 复制环境变量文件：
```bash
cp .env.example .env
```

2. 修改 `.env` 文件中的数据库密码

3. 启动所有服务：
```bash
docker-compose up -d
```

4. 访问 `http://localhost` 查看应用

### 本地开发

#### 前端开发

```bash
cd frontend
npm install
npm run dev
```

访问 `http://localhost:3000`

#### 后端开发

```bash
cd backend
pip install -r requirements.txt
# 设置环境变量 DATABASE_URL
uvicorn app.main:app --reload --port 8000
```

访问 `http://localhost:8000` 查看 API 文档

#### 数据库迁移

```bash
cd backend
alembic upgrade head
```

## 项目结构

```
.
├── frontend/           # 前端项目
│   ├── src/
│   │   ├── api/       # API 调用
│   │   ├── components/# 组件
│   │   ├── views/     # 页面
│   │   ├── stores/    # 状态管理
│   │   └── router/    # 路由
│   └── Dockerfile
├── backend/           # 后端项目
│   ├── app/
│   │   ├── api/       # API 路由
│   │   ├── models/    # 数据模型
│   │   ├── schemas/   # Pydantic 模式
│   │   ├── crud/      # 数据库操作
│   │   └── core/      # 核心配置
│   ├── alembic/       # 数据库迁移
│   └── Dockerfile
├── docker/            # Docker 配置
│   ├── nginx.conf
│   └── init.sql
├── data/              # 数据持久化
│   └── uploads/
└── docker-compose.yml
```

## API 文档

启动后端服务后，访问 `http://localhost:8000/docs` 查看完整的 API 文档。

## 配置说明

主要配置项见 `.env.example`：

- `MYSQL_ROOT_PASSWORD`: MySQL root 密码
- `MYSQL_USER`: MySQL 用户名
- `MYSQL_PASSWORD`: MySQL 密码
- `UPLOAD_DIR`: 文件上传目录

## 开发计划

- [x] 项目初始化
- [ ] 文件上传功能
- [ ] 资源列表与分页
- [ ] 在线预览
- [ ] 分类系统
- [ ] 标签系统
- [ ] 搜索功能

## License

MIT
