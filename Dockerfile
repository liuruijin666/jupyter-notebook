# 基于官方Python 3.12.11镜像构建
FROM python:3.12.11-slim

# 设置工作目录
WORKDIR /notebooks

# 替换为华为云Ubuntu镜像源
RUN sed -i 's/deb.debian.org/mirrors.huaweicloud.com/g' /etc/apt/sources.list.d/debian.sources

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    libegl1 \
    libgl1 \
    && rm -rf /var/lib/apt/lists/*

# 配置pip使用华为云镜像源
RUN pip config --user set global.index https://mirrors.huaweicloud.com/repository/pypi && \
    pip config --user set global.index-url https://mirrors.huaweicloud.com/repository/pypi/simple && \
    pip config --user set global.trusted-host mirrors.huaweicloud.com

# 升级pip并安装依赖
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    jupyter \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    tensorflow \
    torch \
    torchvision \
    opencv-python \
    requests \
    beautifulsoup4

# 复制启动脚本
COPY start-notebook.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh

# 暴露端口
EXPOSE 8888

# 设置环境变量
ENV JUPYTER_ENABLE_LAB=yes
ENV JUPYTER_PASSWORD=123456

# 使用启动脚本作为入口
CMD ["start-notebook.sh"]
