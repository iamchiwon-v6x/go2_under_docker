# Unitree Go2 MuJoCo 시뮬레이터

[![EN](https://img.shields.io/badge/lang-English-blue.svg)](README.md)

Unitree Go2 로봇의 MuJoCo 시뮬레이션 환경입니다. devcontainer로 Docker 안에 환경을 구성하고, `/workspace/sdk`에 SDK를 설치하며, VNC 데스크톱으로 시뮬레이터 화면을 확인할 수 있습니다.

## 빠른 시작

### 1) 컨테이너 시작

- VS Code: **Reopen in Container**
- devcontainer CLI:
  ```bash
  devcontainer up --workspace-folder .
  devcontainer exec --workspace-folder . bash
  ```

### 2) 시뮬레이터 실행

```bash
./scripts/start_simulator.sh
```

### 3) VNC 데스크톱 확인 (스크린샷)

브라우저에서 http://localhost:6080 을 열고 비밀번호 `unitree`를 입력합니다. MuJoCo 창에 Go2 모델이 보이면 정상입니다.

<img width="1492" height="792" alt="Go2 MuJoCo in VNC" src="https://github.com/user-attachments/assets/c41d2ea3-71a4-4088-a117-975c6cef1497" />

### 4) Stand 예제 실행

시뮬레이터는 켠 상태로, 새 터미널에서 실행합니다:

```bash
./scripts/stand_go2.sh
```

선택 사항(테스트 프로그램):

```bash
./scripts/run_test.sh
```

## 사전 요구 사항

- Docker Desktop
- VS Code + Dev Containers 확장, 또는 devcontainer CLI

## 설치되는 항목

### 베이스 이미지 (Dockerfile)

| 카테고리 | 패키지 | 설명 |
|----------|--------|------|
| Base | Ubuntu 22.04 | `mcr.microsoft.com/devcontainers/base:ubuntu-22.04` |
| ROS2 | ros-humble-ros-base | ROS2 Humble 런타임 |
| ROS2 | ros-humble-rmw-cyclonedds-cpp | CycloneDDS RMW |
| ROS2 | ros-humble-rosidl-generator-dds-idl | DDS IDL 생성기 |
| ROS2 | ros-humble-cv-bridge | OpenCV 브리지 |
| ROS2 | ros-humble-image-transport | Image transport |
| ROS2 Build | ros-dev-tools, python3-colcon-common-extensions, python3-rosdep | 빌드 도구 |
| Python | mujoco, pygame, numpy, opencv-python-headless | 시뮬레이터 의존성 |
| Python | python3-opencv | OpenCV 바인딩 |
| System | cmake, build-essential, mesa libs, glfw | 빌드/그래픽 |
| VNC | desktop-lite feature | 웹 VNC 데스크톱 |

### 최초 실행 시 자동 설치 (post-create.sh)

| 패키지 | 위치 | 설명 |
|--------|------|------|
| unitree_mujoco | `/workspace/sdk/unitree_mujoco` | MuJoCo 시뮬레이터 소스 |
| cyclonedds 0.10.2 | `/usr/local` | DDS 라이브러리 (소스 빌드) |
| unitree_sdk2 | `/workspace/sdk/unitree_sdk2` | C++ SDK (소스 빌드) |
| unitree_sdk2_python | `/workspace/sdk/unitree_sdk2_python` | Python SDK (editable install) |
| unitree_ros2 | `/workspace/ros2_ws/src/unitree_ros2` | ROS2 인터페이스 패키지 |
| ROS2 workspace | `/workspace/ros2_ws` | colcon 빌드 결과 포함 |

## 런타임 환경

스크립트 실행 시 아래 변수가 설정됩니다:

| 변수 | 값 | 설명 |
|------|-----|------|
| `CYCLONEDDS_HOME` | `/usr/local` | CycloneDDS 설치 경로 |
| `CYCLONEDDS_URI` | `file:///workspace/.devcontainer/cyclonedds.xml` | DDS 설정 파일 |
| `RMW_IMPLEMENTATION` | `rmw_cyclonedds_cpp` | DDS 미들웨어 |

## 시뮬레이터 설정

설정 파일: `/workspace/sdk/unitree_mujoco/simulate_python/config.py`

```python
ROBOT = "go2"           # Robot model: "go2", "b2", "b2w", "h1", "go2w", "g1"
ROBOT_SCENE = "..."     # Simulation scene file
DOMAIN_ID = 1           # DDS domain ID (simulation: 1, real robot: 0)
INTERFACE = "lo"        # Network interface (simulation: "lo")
USE_JOYSTICK = 0        # Joystick usage (0 in Docker)
```

## 프로젝트 구조

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

## 참고

- https://github.com/unitreerobotics/unitree_mujoco
- https://github.com/unitreerobotics/unitree_sdk2
- https://github.com/unitreerobotics/unitree_sdk2_python
- https://github.com/unitreerobotics/unitree_ros2
- https://mujoco.readthedocs.io/en/stable/overview.html
- https://support.unitree.com/home/zh/developer
