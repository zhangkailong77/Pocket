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

**选项 1：使用外部数据库（推荐）**

如果你已有局域网内的 MySQL 数据库（如 192.168.31.11:3306）：

1. 复制环境变量文件：
```bash
cp .env.example .env
```

2. 修改 `.env` 文件中的数据库配置：
```bash
MYSQL_HOST=192.168.31.11
MYSQL_USER=root
MYSQL_PASSWORD=123456
```

3. 启动服务（不启动 MySQL 容器）：
```bash
docker-compose up -d backend frontend nginx
```

4. 访问 `http://localhost` 查看应用

**选项 2：使用 Docker 内置 MySQL**

1. 复制环境变量文件：
```bash
cp .env.example .env
```

2. 启动所有服务：
```bash
docker-compose up -d
```

3. 访问 `http://localhost` 查看应用

### 本地开发

#### 前端开发

```bash
cd frontend
npm install
npm run dev
```

访问 `http://localhost:3000`

#### 后端开发（使用 conda 虚拟环境）

**首次使用 - 环境设置**：

```bash
cd backend

# Windows
setup_conda.bat

# Linux/Mac
bash setup_conda.sh
```

这个脚本会：
- 创建名为 `pocket-backend` 的 conda 虚拟环境（Python 3.11）
- 安装所有依赖包
- 配置数据库连接

**初始化数据库**：

```bash
cd backend

# Windows
init_db.bat

# Linux/Mac
bash init_db.sh
```

**启动后端服务**：

```bash
cd backend

# Windows
start_server.bat

# Linux/Mac
bash start_server.sh
```

或手动执行：
```bash
conda activate pocket-backend
set DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket  # Windows
export DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket  # Linux/Mac
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

访问 `http://localhost:8000` 查看 API 文档

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

- `MYSQL_HOST`: MySQL 服务器地址（默认：192.168.31.11）
- `MYSQL_PORT`: MySQL 端口（默认：3306）
- `MYSQL_USER`: MySQL 用户名（默认：root）
- `MYSQL_PASSWORD`: MySQL 密码（默认：123456）
- `MYSQL_DATABASE`: 数据库名（默认：pocket）
- `DATABASE_URL`: 完整数据库连接字符串
- `UPLOAD_DIR`: 文件上传目录

**注意**：
- 如果使用局域网内的 MySQL，直接修改 `backend/app/core/config.py` 和 `.env` 文件
- 确保数据库服务器允许外部连接（检查 MySQL 的 bind-address 和防火墙设置）
- 首次使用需要先创建 `pocket` 数据库并运行 `docker/init.sql` 初始化表结构

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
