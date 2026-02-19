# Unitree Go2 MuJoCo 시뮬레이터

Unitree Go2 로봇의 MuJoCo 시뮬레이션 환경입니다. devcontainer를 사용하여 Docker 안에서 Ubuntu 환경을 구성하고, VNC를 통해 시뮬레이터 화면을 볼 수 있습니다.

<img width="1492" height="792" alt="image" src="https://github.com/user-attachments/assets/c41d2ea3-71a4-4088-a117-975c6cef1497" />

## 사전 요구 사항

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- 다음 중 하나:
  - [VS Code](https://code.visualstudio.com/) + [Dev Containers 확장](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [devcontainer CLI](https://github.com/devcontainers/cli) (`npm install -g @devcontainers/cli`)

## 환경 구축

### 방법 1: VS Code 사용 (권장)

1. 이 레포지토리를 클론합니다.
   ```bash
   git clone https://github.com/iamchiwon-v6x/go2_under_docker.git
   cd go2_under_docker
   ```

2. VS Code에서 폴더를 엽니다.
   ```bash
   code .
   ```

3. 좌하단 `><` 아이콘을 클릭하고 **Reopen in Container**를 선택합니다.

4. 컨테이너 빌드와 의존성 설치가 자동으로 진행됩니다 (최초 약 5~10분 소요).

### 방법 2: devcontainer CLI 사용

```bash
git clone https://github.com/iamchiwon-v6x/go2_under_docker.git
cd go2_under_docker
devcontainer up --workspace-folder .
```

컨테이너가 시작되면 셸에 접속합니다:

```bash
devcontainer exec --workspace-folder . bash
```

> **Tip**: 테스트 시 터미널이 2개 필요합니다 (시뮬레이터용 + 제어 프로그램용). 위 명령을 두 개의 터미널에서 각각 실행하세요.

### 컨테이너에 설치되는 항목

#### Docker 이미지 (Dockerfile)

| 카테고리 | 항목 | 설명 |
|----------|------|------|
| 베이스 | Ubuntu 22.04 | `mcr.microsoft.com/devcontainers/base:ubuntu-22.04` |
| ROS2 | ros-humble-ros-base | ROS2 Humble 핵심 런타임 |
| ROS2 | ros-humble-rmw-cyclonedds-cpp | CycloneDDS RMW 구현체 |
| ROS2 | ros-humble-rosidl-generator-dds-idl | DDS IDL 생성기 |
| ROS2 | ros-humble-cv-bridge | OpenCV-ROS2 브릿지 |
| ROS2 | ros-humble-image-transport | 이미지 전송 라이브러리 |
| ROS2 빌드 | ros-dev-tools, python3-colcon-common-extensions, python3-rosdep | ROS2 빌드 도구 |
| Python | mujoco, pygame, numpy, opencv-python-headless | 시뮬레이터 의존성 |
| Python | python3-opencv | OpenCV Python 바인딩 |
| 시스템 | cmake, build-essential, libgl1-mesa-dev 등 | 빌드 및 그래픽 라이브러리 |
| VNC | desktop-lite (devcontainer feature) | 웹 브라우저 VNC 데스크톱 |

#### 자동 설치 (post-create.sh)

컨테이너 최초 생성 시 자동으로 실행됩니다:

| 항목 | 설명 |
|------|------|
| [unitree_mujoco](https://github.com/unitreerobotics/unitree_mujoco) | MuJoCo 기반 Unitree 로봇 시뮬레이터 |
| [cyclonedds 0.10.2](https://github.com/eclipse-cyclonedds/cyclonedds) | DDS 통신 라이브러리 (소스 빌드) |
| [unitree_sdk2_python](https://github.com/unitreerobotics/unitree_sdk2_python) | Unitree SDK2 Python 바인딩 |
| ROS2 워크스페이스 | `/workspace/ros2_ws/` 초기화 및 빌드 |

#### 환경 변수

| 변수 | 값 | 설명 |
|------|-----|------|
| `ROS_DOMAIN_ID` | `0` | ROS2 도메인 ID |
| `ROS_LOCALHOST_ONLY` | `1` | DDS discovery를 localhost로 제한 (Docker 호환) |
| `RMW_IMPLEMENTATION` | `rmw_cyclonedds_cpp` | DDS 미들웨어 구현체 |
| `CYCLONEDDS_URI` | `file:///.../cyclonedds.xml` | CycloneDDS 설정 파일 |
| `CYCLONEDDS_HOME` | `/usr/local` | CycloneDDS 설치 경로 |

## 빠른 시작

### 1. 시뮬레이터 실행

컨테이너 터미널에서:

```bash
./scripts/start_simulator.sh
```

### 2. VNC로 시뮬레이터 화면 확인

브라우저에서 **http://localhost:6080** 을 열면 VNC 데스크톱이 나타납니다.
- 비밀번호: `unitree`
- MuJoCo 창에 Go2 로봇이 보이면 정상입니다.

### 3. 제어 프로그램 실행

시뮬레이터를 켜둔 상태에서, **별도의 터미널**을 열어 제어 프로그램을 실행합니다.

VS Code에서는 `Ctrl+Shift+~` 로 새 터미널을 열 수 있습니다. devcontainer CLI를 사용하는 경우 새 터미널 탭에서 `devcontainer exec --workspace-folder . bash`로 접속하세요.

```bash
# 기본 테스트: 각 모터에 1Nm 토크를 인가하고 상태를 출력합니다
./scripts/run_test.sh

# Go2 일어서기/눕기 예제
./scripts/stand_go2.sh
```

### 스크립트 목록

| 스크립트 | 설명 |
|----------|------|
| `scripts/start_simulator.sh` | MuJoCo 시뮬레이터 실행 |
| `scripts/run_test.sh` | 기본 모터 테스트 (시뮬레이터 실행 필요) |
| `scripts/stand_go2.sh` | Go2 일어서기 예제 (시뮬레이터 실행 필요) |

## 시뮬레이터 설정

설정 파일: `unitree_mujoco/simulate_python/config.py`

```python
ROBOT = "go2"           # 로봇 모델: "go2", "b2", "b2w", "h1", "go2w", "g1"
ROBOT_SCENE = "..."     # 시뮬레이션 씬 파일
DOMAIN_ID = 1           # DDS 도메인 ID (시뮬레이션: 1, 실제 로봇: 0)
INTERFACE = "lo"        # 네트워크 인터페이스 (시뮬레이션: "lo")
USE_JOYSTICK = 0        # 조이스틱 사용 여부 (Docker에서는 0)
```

## 종료 방법

### 시뮬레이터 종료

시뮬레이터 터미널에서 `Ctrl+C`를 눌러 종료합니다.

### VS Code 사용 시

- 좌하단 `><` 아이콘 → **Reopen Folder Locally**를 선택하면 컨테이너에서 빠져나옵니다.
- 컨테이너를 완전히 삭제하려면 Docker Desktop에서 해당 컨테이너를 삭제합니다.

### devcontainer CLI 사용 시

```bash
# 컨테이너 ID 확인
docker ps --filter "label=devcontainer.local_folder=$(pwd)" --format "{{.ID}}"

# 컨테이너 정지
docker stop <CONTAINER_ID>

# 컨테이너 삭제 (필요 시)
docker rm <CONTAINER_ID>
```

## 프로젝트 구조

```
go2_under_docker/
├── .devcontainer/
│   ├── devcontainer.json    # devcontainer 설정 (VNC, 포트 매핑, 환경 변수)
│   ├── Dockerfile           # Ubuntu 22.04 + 시스템 의존성
│   ├── post-create.sh       # 자동 설치 스크립트
│   └── cyclonedds.xml       # CycloneDDS 통신 설정
├── scripts/
│   ├── start_simulator.sh   # 시뮬레이터 실행
│   ├── run_test.sh          # 기본 모터 테스트
│   └── stand_go2.sh         # Go2 일어서기 예제
├── .gitignore
├── README.md
└── unitree_mujoco/          # (컨테이너 생성 시 자동 클론)
    ├── simulate_python/     # Python 시뮬레이터 (기본 사용)
    ├── unitree_robots/      # 로봇 MJCF 모델 파일
    ├── terrain_tool/        # 지형 생성 도구
    └── example/             # 예제 프로그램 (stand_go2 등)
```

## 참고 자료

- [unitree_mujoco](https://github.com/unitreerobotics/unitree_mujoco) - 시뮬레이터 원본 레포지토리
- [unitree_sdk2_python](https://github.com/unitreerobotics/unitree_sdk2_python) - Python SDK
- [MuJoCo 문서](https://mujoco.readthedocs.io/en/stable/overview.html)
- [Unitree 개발자 문서](https://support.unitree.com/home/zh/developer)
