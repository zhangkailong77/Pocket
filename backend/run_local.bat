@echo off
REM 本地开发启动脚本 - 连接外部数据库

echo 设置环境变量
set DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket
set UPLOAD_DIR=./data/uploads

echo 启动后端服务...
python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
