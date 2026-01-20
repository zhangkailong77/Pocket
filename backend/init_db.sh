#!/bin/bash
# 初始化数据库 - Linux/Mac

echo "连接到 MySQL 服务器并初始化数据库..."
echo ""
echo "服务器: 192.168.31.11:3306"
echo "用户: root"
echo "数据库: pocket"
echo ""

mysql -h 192.168.31.11 -u root -p123456 -e "CREATE DATABASE IF NOT EXISTS pocket CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

if [ $? -ne 0 ]; then
    echo "错误: 无法连接到数据库或创建数据库"
    echo "请检查:"
    echo "1. MySQL 服务是否运行"
    echo "2. 网络连接是否正常"
    echo "3. 用户名密码是否正确"
    exit 1
fi

echo ""
echo "导入数据库表结构和初始数据..."
mysql -h 192.168.31.11 -u root -p123456 pocket < ../docker/init.sql

if [ $? -ne 0 ]; then
    echo "错误: 导入 SQL 失败"
    exit 1
fi

echo ""
echo "========================================"
echo "数据库初始化成功！"
echo "========================================"
echo ""
