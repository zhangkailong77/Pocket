@echo off
REM 启动 Pocket 后端服务 - Windows

echo 激活 conda 虚拟环境...
call conda activate pocket-backend

if errorlevel 1 (
    echo 错误: 无法激活虚拟环境 pocket-backend
    echo 请先运行 setup_conda.bat 创建环境
    pause
    exit /b 1
)

echo 设置环境变量...
set DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket
set UPLOAD_DIR=./data/uploads

echo.
echo 启动后端服务...
echo 访问: http://localhost:8000
echo API 文档: http://localhost:8000/docs
echo.
echo 按 Ctrl+C 停止服务
echo.

python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
