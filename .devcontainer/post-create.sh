#!/bin/bash
set -e

echo "=== Cloning unitree_mujoco ==="
cd /workspace
if [ ! -d "unitree_mujoco" ]; then
    git clone https://github.com/unitreerobotics/unitree_mujoco.git
fi

echo "=== Installing cyclonedds ==="
cd /tmp
if [ ! -d "cyclonedds" ]; then
    git clone https://github.com/eclipse-cyclonedds/cyclonedds.git -b 0.10.2
fi
cd cyclonedds
mkdir -p build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local
make -j$(nproc)
sudo make install

echo "=== Installing unitree_sdk2_python ==="
export CYCLONEDDS_HOME=/usr/local
cd /tmp
if [ ! -d "unitree_sdk2_python" ]; then
    git clone https://github.com/unitreerobotics/unitree_sdk2_python.git
fi
cd unitree_sdk2_python
pip3 install -e .

echo "=== Configuring simulator for Docker (no joystick) ==="
sed -i 's/USE_JOYSTICK = 1/USE_JOYSTICK = 0/' /workspace/unitree_mujoco/simulate_python/config.py

echo "=== Allow X11 access ==="
cp /home/vscode/.Xauthority /root/.Xauthority 2>/dev/null || true

echo ""
echo "============================================"
echo "  Setup complete!"
echo "  VNC desktop: http://localhost:6080"
echo "  Password: unitree"
echo "============================================"
