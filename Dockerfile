FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 替换为华为云Ubuntu镜像源
RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
    sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list && \

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    tzdata \
    build-essential \
    libssl-dev \
    libffi-dev \
    libegl1 \
    libgl1 \
    wget \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update && apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-dev \
    python3-distutils \
    && rm -rf /var/lib/apt/lists/* && \
    alias python3='python3.12' && \
    alias python='python3.12'

# 安装pip for Python 3.12（使用官方脚本确保兼容性）
RUN wget https://bootstrap.pypa.io/get-pip.py -O get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# 配置pip使用华为云镜像源
RUN pip3 config --user set global.index https://mirrors.huaweicloud.com/repository/pypi && \
    pip3 config --user set global.index-url https://mirrors.huaweicloud.com/repository/pypi/simple && \
    pip3 config --user set global.trusted-host mirrors.huaweicloud.com && \
    pip3 install --upgrade pip

# 安装Jupyter及依赖（使用最新兼容版本）
RUN pip3 install --no-cache-dir \
    jupyter \
    jupyter-server>=2.10.0 \
    notebook>=7.0.0 \
    jupyterlab-language-pack-zh-CN \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    tensorflow[and-cuda] \
    segment-geospatial \
    # 安装与CUDA 12.4兼容的PyTorch
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# 创建工作目录
WORKDIR /notebooks

# 暴露端口
EXPOSE 8888

# 设置启动脚本权限
COPY start-notebook.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-notebook.sh

# 启动命令
CMD ["start-notebook.sh"]
