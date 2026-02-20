#!/bin/bash
set -e

SDK_ROOT="/workspace/sdk"
mkdir -p "$SDK_ROOT"

echo "=== Updating Package List & Installing Dependencies ==="
sudo apt-get update
sudo apt-get install -y \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-ros-base \
    ros-humble-cv-bridge \
    ros-humble-image-transport \
    python3-pip \
    cmake \
    git

echo "=== Sourcing ROS2 Humble ==="
source /opt/ros/humble/setup.bash

echo "=== Cloning unitree_mujoco ==="
cd "$SDK_ROOT"
if [ ! -d "unitree_mujoco" ]; then
    git clone https://github.com/unitreerobotics/unitree_mujoco.git
fi

echo "=== Installing cyclonedds (Source Build) ==="
cd /tmp
if [ ! -d "cyclonedds" ]; then
    git clone https://github.com/eclipse-cyclonedds/cyclonedds.git -b 0.10.2
fi
cd cyclonedds
if [ ! -d "build" ]; then
    mkdir -p build && cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
    make -j$(nproc)
    sudo make install
fi

# C++ SDK 설치 부분 추가
echo "=== Installing unitree_sdk2 (C++) ==="
cd "$SDK_ROOT"
if [ ! -d "unitree_sdk2" ]; then
    git clone https://github.com/unitreerobotics/unitree_sdk2.git
fi
cd unitree_sdk2 && mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX="$SDK_ROOT/unitree_sdk2/install"
make -j$(nproc)
make install

echo "=== Installing unitree_sdk2_python ==="
export CYCLONEDDS_HOME=/usr/local
cd "$SDK_ROOT"
if [ ! -d "unitree_sdk2_python" ]; then
    git clone https://github.com/unitreerobotics/unitree_sdk2_python.git
fi

echo "=== Patching unitree_sdk2py (remove unused b2 import) ==="
sed -i 's/from . import idl, utils, core, rpc, go2, b2/from . import idl, utils, core, rpc, go2/' \
    "$SDK_ROOT/unitree_sdk2_python/unitree_sdk2py/__init__.py"

cd "$SDK_ROOT/unitree_sdk2_python"
sudo -E pip3 install -e .

echo "=== Setting up ROS2 workspace with unitree_ros2 ==="
mkdir -p /workspace/ros2_ws/src
cd /workspace/ros2_ws/src

# Go2 카메라 및 센서 토픽 해석을 위한 핵심 인터페이스 패키지
if [ ! -d "unitree_ros2" ]; then
    git clone https://github.com/unitreerobotics/unitree_ros2.git
fi

cd /workspace/ros2_ws
source /opt/ros/humble/setup.bash
# unitree_go 메시지 패키지를 포함하여 빌드
colcon build --symlink-install

echo "=== Configuring simulator for Docker (no joystick) ==="
sed -i 's/USE_JOYSTICK = 1/USE_JOYSTICK = 0/' /workspace/sdk/unitree_mujoco/simulate_python/config.py

echo "=== Allow X11 access ==="
cp /home/vscode/.Xauthority /root/.Xauthority 2>/dev/null || true

echo ""
echo "============================================"
echo "  Setup complete!"
echo "  ROS2 Humble: $(ros2 --version 2>/dev/null | head -n 1 || echo 'Installed')"
echo "  RMW: $RMW_IMPLEMENTATION"
echo "  Workspace: /workspace/ros2_ws"
echo "  VNC desktop: http://localhost:6080"
echo "============================================"