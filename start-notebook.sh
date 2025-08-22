#!/bin/bash

# 检查是否设置了密码环境变量
if [ -z "$JUPYTER_PASSWORD" ]; then
    echo "警告: 未设置JUPYTER_PASSWORD环境变量，使用无密码模式启动"
    PASSWORD_OPTION=""
else
    # 使用Python生成密码哈希
    HASHED_PASSWORD=$(python -c "from notebook.auth import passwd; print(passwd('$JUPYTER_PASSWORD'))")
    PASSWORD_OPTION="--NotebookApp.password='$HASHED_PASSWORD'"
fi

# 启动Jupyter Notebook
exec jupyter notebook \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    $PASSWORD_OPTION
