FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    cmake \
    build-essential \
    git \
    wget \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
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

# Install ROS2 Humble
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2.list \
    && apt-get update && apt-get install -y \
    ros-humble-ros-base \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-rosidl-generator-dds-idl \
    ros-humble-cv-bridge \
    ros-humble-image-transport \
    ros-dev-tools \
    python3-colcon-common-extensions \
    python3-rosdep \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init || true \
    && su vscode -c "rosdep update" || true

# Source ROS2 setup in bash for all users
RUN echo "source /opt/ros/humble/setup.bash" >> /etc/bash.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> /home/vscode/.bashrc

RUN pip3 install --no-cache-dir \
    mujoco \
    pygame \
    numpy \
    opencv-python-headless

WORKDIR /workspace
