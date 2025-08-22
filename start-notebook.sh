#!/bin/bash

# 清理可能冲突的配置文件
rm -rf ~/.jupyter/jupyter_notebook_config.json
rm -rf ~/.jupyter/jupyter_server_config.json

# 打印GPU信息，验证GPU是否可用
echo "检查GPU状态:"
nvidia-smi || echo "未检测到NVIDIA GPU"

# 检查是否设置了密码环境变量
if [ -n "$JUPYTER_PASSWORD" ]; then
    echo "检测到JUPYTER_PASSWORD环境变量，使用密码登录模式"
    # 生成密码哈希
    HASHED_PASSWORD=$(python3 -c "from jupyter_server.auth import passwd; print(passwd('$JUPYTER_PASSWORD'))")
    AUTH_OPTIONS="--ServerApp.password='$HASHED_PASSWORD' --ServerApp.token=''"
else
    echo "未设置JUPYTER_PASSWORD环境变量，使用无密码登录模式"
    AUTH_OPTIONS="--ServerApp.token='' --ServerApp.password=''"
fi

# 启动Jupyter Notebook
exec jupyter notebook \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    $AUTH_OPTIONS
