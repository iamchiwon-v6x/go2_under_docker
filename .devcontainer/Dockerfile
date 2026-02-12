FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    cmake \
    build-essential \
    git \
    wget \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libegl1-mesa-dev \
    libgles2-mesa-dev \
    libglfw3 \
    libglfw3-dev \
    libxrandr2 \
    libxinerama1 \
    libxcursor1 \
    libxi6 \
    libxxf86vm1 \
    libyaml-cpp-dev \
    libspdlog-dev \
    libboost-all-dev \
    mesa-utils \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir \
    mujoco \
    pygame \
    numpy

WORKDIR /workspace
