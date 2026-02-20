# Unitree Go2 MuJoCo Simulator

[![한국어](https://img.shields.io/badge/lang-한국어-blue.svg)](README.ko.md)

A devcontainer-based MuJoCo simulation setup for the Unitree Go2 robot. It builds the SDKs under `/workspace/sdk` and exposes a VNC desktop so you can run the simulator in a browser.

## Quickstart

### 1) Start the container

- VS Code: **Reopen in Container**
- devcontainer CLI:
  ```bash
  devcontainer up --workspace-folder .
  devcontainer exec --workspace-folder . bash
  ```

### 2) Run the simulator

```bash
./scripts/start_simulator.sh
```

### 3) View the VNC desktop (screenshot)

Open http://localhost:6080 (password: `unitree`). You should see the Go2 model running in MuJoCo.

<img width="1492" height="792" alt="Go2 MuJoCo in VNC" src="https://github.com/user-attachments/assets/c41d2ea3-71a4-4088-a117-975c6cef1497" />

### 4) Run the stand example

Open a second terminal (the simulator must keep running):

```bash
./scripts/stand_go2.sh
```

Optional test program:

```bash
./scripts/run_test.sh
```

## Prerequisites

- Docker Desktop
- VS Code + Dev Containers extension, or devcontainer CLI

## What Gets Installed

### Base Image (Dockerfile)

| Category | Package | Notes |
|----------|---------|-------|
| Base | Ubuntu 22.04 | `mcr.microsoft.com/devcontainers/base:ubuntu-22.04` |
| ROS2 | ros-humble-ros-base | ROS2 Humble runtime |
| ROS2 | ros-humble-rmw-cyclonedds-cpp | CycloneDDS RMW |
| ROS2 | ros-humble-rosidl-generator-dds-idl | DDS IDL generator |
| ROS2 | ros-humble-cv-bridge | OpenCV bridge |
| ROS2 | ros-humble-image-transport | Image transport |
| ROS2 Build | ros-dev-tools, python3-colcon-common-extensions, python3-rosdep | Build tools |
| Python | mujoco, pygame, numpy, opencv-python-headless | Simulator deps |
| Python | python3-opencv | OpenCV bindings |
| System | cmake, build-essential, mesa libs, glfw | Build/graphics |
| VNC | desktop-lite feature | Web VNC desktop |

### Auto-Installed on First Run (post-create.sh)

| Package | Location | Description |
|---------|----------|-------------|
| unitree_mujoco | `/workspace/sdk/unitree_mujoco` | MuJoCo simulator source |
| cyclonedds 0.10.2 | `/usr/local` | DDS library (source build) |
| unitree_sdk2 | `/workspace/sdk/unitree_sdk2` | C++ SDK (source build) |
| unitree_sdk2_python | `/workspace/sdk/unitree_sdk2_python` | Python SDK (editable install) |
| unitree_ros2 | `/workspace/ros2_ws/src/unitree_ros2` | ROS2 interface packages |
| ROS2 workspace | `/workspace/ros2_ws` | Built with colcon |

## Runtime Environment

The scripts export these at runtime:

| Variable | Value | Description |
|----------|-------|-------------|
| `CYCLONEDDS_HOME` | `/usr/local` | CycloneDDS install path |
| `CYCLONEDDS_URI` | `file:///workspace/.devcontainer/cyclonedds.xml` | DDS config file |
| `RMW_IMPLEMENTATION` | `rmw_cyclonedds_cpp` | DDS middleware |

## Simulator Configuration

Config file: `/workspace/sdk/unitree_mujoco/simulate_python/config.py`

```python
ROBOT = "go2"           # Robot model: "go2", "b2", "b2w", "h1", "go2w", "g1"
ROBOT_SCENE = "..."     # Simulation scene file
DOMAIN_ID = 1           # DDS domain ID (simulation: 1, real robot: 0)
INTERFACE = "lo"        # Network interface (simulation: "lo")
USE_JOYSTICK = 0        # Joystick usage (0 in Docker)
```

## Project Structure

```
go2_under_docker/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── post-create.sh
│   └── cyclonedds.xml
├── scripts/
│   ├── start_simulator.sh
│   ├── run_test.sh
│   └── stand_go2.sh
├── ros2_ws/
│   ├── src/
│   │   └── unitree_ros2/
│   ├── build/
│   ├── install/
│   └── log/
├── sdk/
│   ├── unitree_mujoco/
│   ├── unitree_sdk2/
│   └── unitree_sdk2_python/
├── README.md
└── README.ko.md
```

## References

- https://github.com/unitreerobotics/unitree_mujoco
- https://github.com/unitreerobotics/unitree_sdk2
- https://github.com/unitreerobotics/unitree_sdk2_python
- https://github.com/unitreerobotics/unitree_ros2
- https://mujoco.readthedocs.io/en/stable/overview.html
- https://support.unitree.com/home/zh/developer
