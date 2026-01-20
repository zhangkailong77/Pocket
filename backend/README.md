# Pocket 后端

FastAPI 后端服务，用于管理个人资源仓库。

## 环境要求

- Python 3.11+
- Conda (Anaconda 或 Miniconda)
- MySQL 8.0+
- 局域网数据库访问权限

## 快速开始

### 1. 环境设置

首次使用需要创建 conda 虚拟环境：

**Windows:**
```bash
setup_conda.bat
```

**Linux/Mac:**
```bash
bash setup_conda.sh
```

这会自动：
- 创建 `pocket-backend` 虚拟环境
- 安装所有 Python 依赖
- 配置数据库连接参数

### 2. 初始化数据库

**Windows:**
```bash
init_db.bat
```

**Linux/Mac:**
```bash
bash init_db.sh
```

或手动执行：
```bash
mysql -h 192.168.31.11 -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS pocket"
mysql -h 192.168.31.11 -u root -p123456 pocket < ../docker/init.sql
```

### 3. 启动服务

**Windows:**
```bash
start_server.bat
```

**Linux/Mac:**
```bash
bash start_server.sh
```

服务启动后访问：
- API 服务: http://localhost:8000
- API 文档: http://localhost:8000/docs
- 交互式文档: http://localhost:8000/redoc

## 手动操作

### 激活虚拟环境

```bash
conda activate pocket-backend
```

### 安装依赖

如果 `environment.yml` 失败，可使用 pip：

```bash
pip install -r requirements.txt
```

### 运行服务

```bash
# Windows
set DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000

# Linux/Mac
export DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 数据库迁移

使用 Alembic 进行数据库版本管理：

```bash
# 生成迁移脚本
alembic revision --autogenerate -m "描述信息"

# 执行迁移
alembic upgrade head

# 回滚迁移
alembic downgrade -1
```

## 项目结构

```
backend/
├── app/
│   ├── api/              # API 路由
│   ├── core/             # 核心配置
│   │   ├── config.py     # 配置管理
│   │   └── database.py   # 数据库连接
│   ├── models/           # SQLAlchemy 模型
│   │   ├── resource.py   # 资源模型
│   │   ├── category.py   # 分类模型
│   │   └── tag.py        # 标签模型
│   ├── schemas/          # Pydantic 模式
│   ├── crud/             # 数据库操作
│   ├── utils/            # 工具函数
│   └── main.py           # 应用入口
├── alembic/              # 数据库迁移
│   ├── versions/
│   └── env.py
├── tests/                # 测试
├── environment.yml       # Conda 环境配置
├── requirements.txt      # Pip 依赖
├── alembic.ini          # Alembic 配置
├── setup_conda.bat      # Windows 环境设置脚本
├── setup_conda.sh       # Linux/Mac 环境设置脚本
├── init_db.bat          # Windows 数据库初始化
├── init_db.sh           # Linux/Mac 数据库初始化
├── start_server.bat     # Windows 启动脚本
└── start_server.sh      # Linux/Mac 启动脚本
```

## 环境变量

主要环境变量已在 `start_server.bat/sh` 中配置：

- `DATABASE_URL`: MySQL 连接字符串
- `UPLOAD_DIR`: 文件上传目录

可在脚本中修改这些值，或创建 `.env` 文件。

## 开发说明

### 添加新的 API 端点

1. 在 `app/api/` 创建路由文件
2. 在 `app/main.py` 中注册路由
3. 创建对应的 Pydantic schemas（如果需要）
4. 实现 CRUD 操作（如果需要）

### 数据库模型变更

1. 修改 `app/models/` 中的模型
2. 生成迁移：`alembic revision --autogenerate -m "描述"`
3. 检查生成的迁移脚本
4. 执行迁移：`alembic upgrade head`

## 依赖说明

主要依赖包：

- `fastapi`: Web 框架
- `uvicorn`: ASGI 服务器
- `sqlalchemy`: ORM
- `pymysql`: MySQL 驱动
- `pydantic`: 数据验证
- `alembic`: 数据库迁移
- `aiofiles`: 异步文件操作

## 故障排查

### 连接数据库失败

1. 检查 MySQL 服务是否运行
2. 检查网络连接（ping 192.168.31.11）
3. 检查 MySQL 用户权限
4. 确认防火墙设置

### conda 命令不可用

确保已安装 Anaconda 或 Miniconda，并添加到系统 PATH。

### 端口被占用

修改 `start_server.bat/sh` 中的端口号，或终止占用 8000 端口的进程。

## 生产部署

生产环境建议：

1. 使用 Gunicorn + Uvicorn workers
2. 配置 HTTPS
3. 设置环境变量文件
4. 使用进程管理器（systemd、supervisor等）
5. 配置日志记录

示例：
```bash
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```
