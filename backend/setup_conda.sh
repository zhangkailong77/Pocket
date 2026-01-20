#!/bin/bash
# Pocket 后端环境设置脚本 - Linux/Mac
# 使用 conda 创建虚拟环境并安装依赖

echo "========================================"
echo "Pocket 后端环境设置"
echo "========================================"

# 检查 conda 是否可用
if ! command -v conda &> /dev/null; then
    echo "错误: 未找到 conda，请先安装 Anaconda 或 Miniconda"
    exit 1
fi

echo ""
echo "[1/4] 创建 conda 虚拟环境..."
conda env create -f environment.yml --force
if [ $? -ne 0 ]; then
    echo "创建环境失败，尝试使用 requirements.txt..."
    conda create -n pocket-backend python=3.11 -y
    source $(conda info --base)/etc/profile.d/conda.sh
    conda activate pocket-backend
    pip install -r requirements.txt
else
    echo "环境创建成功！"
fi

echo ""
echo "[2/4] 激活虚拟环境..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate pocket-backend

echo ""
echo "[3/4] 检查数据库连接..."
python -c "import pymysql; print('数据库驱动安装成功')"

echo ""
echo "[4/4] 设置环境变量..."
export DATABASE_URL=mysql+pymysql://root:123456@192.168.31.11:3306/pocket
export UPLOAD_DIR=./data/uploads

echo ""
echo "========================================"
echo "环境设置完成！"
echo "========================================"
echo ""
echo "后续操作："
echo "1. 初始化数据库（首次运行）:"
echo "   mysql -h 192.168.31.11 -u root -p123456 pocket < ../docker/init.sql"
echo ""
echo "2. 启动后端服务:"
echo "   conda activate pocket-backend"
echo "   python -m uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"
echo ""
echo "或使用: bash start_server.sh"
echo ""
