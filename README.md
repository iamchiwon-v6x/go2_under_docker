# Unitree Go2 MuJoCo 시뮬레이터

Unitree Go2 로봇의 MuJoCo 시뮬레이션 환경입니다. devcontainer를 사용하여 Docker 안에서 Ubuntu 환경을 구성하고, VNC를 통해 시뮬레이터 화면을 볼 수 있습니다.

<img width="1492" height="792" alt="image" src="https://github.com/user-attachments/assets/c41d2ea3-71a4-4088-a117-975c6cef1497" />


## 사전 요구 사항

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- 다음 중 하나:
  - [VS Code](https://code.visualstudio.com/) + [Dev Containers 확장](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [devcontainer CLI](https://github.com/devcontainers/cli) (`npm install -g @devcontainers/cli`)

## 환경 구축

### 방법 1: VS Code 사용

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
npx @devcontainers/cli up --workspace-folder .
```

### 자동으로 설치되는 항목

컨테이너 생성 시 `post-create.sh`가 자동으로 다음을 설치합니다:

| 항목 | 설명 |
|------|------|
| [unitree_mujoco](https://github.com/unitreerobotics/unitree_mujoco) | MuJoCo 기반 Unitree 로봇 시뮬레이터 |
| [cyclonedds 0.10.2](https://github.com/eclipse-cyclonedds/cyclonedds) | DDS 통신 라이브러리 (소스 빌드) |
| [unitree_sdk2_python](https://github.com/unitreerobotics/unitree_sdk2_python) | Unitree SDK2 Python 바인딩 |
| mujoco, pygame, numpy | Python 시뮬레이터 의존성 |

## 사용 방법

### 시뮬레이터 실행

1. 컨테이너 내부 터미널에서 시뮬레이터를 시작합니다.
   ```bash
   export DISPLAY=:1
   export XAUTHORITY=/home/vscode/.Xauthority
   export LIBGL_ALWAYS_SOFTWARE=1
   cd /workspace/unitree_mujoco/simulate_python
   python3 unitree_mujoco.py
   ```

2. 브라우저에서 **http://localhost:6080** 을 열어 VNC 데스크톱을 확인합니다.
   - 비밀번호: `unitree`
   - MuJoCo 시뮬레이터 창에서 Go2 로봇이 보입니다.

### 호스트에서 직접 실행 (devcontainer CLI 사용 시)

```bash
# 컨테이너 ID 확인
docker ps --filter "label=devcontainer.local_folder=$(pwd)" --format "{{.ID}}"

# 시뮬레이터 실행
docker exec -d <CONTAINER_ID> bash -c '\
  export DISPLAY=:1 && \
  export XAUTHORITY=/home/vscode/.Xauthority && \
  export LIBGL_ALWAYS_SOFTWARE=1 && \
  cd /workspace/unitree_mujoco/simulate_python && \
  python3 unitree_mujoco.py'
```

### 테스트 프로그램 실행

시뮬레이터가 실행 중인 상태에서 **별도의 터미널**을 열고:

```bash
cd /workspace/unitree_mujoco/simulate_python
python3 ./test/test_unitree_sdk2.py
```

이 프로그램은 로봇의 자세와 위치 정보를 출력하며, 각 모터에 1Nm 토크를 인가합니다.

### 시뮬레이터 설정 변경

설정 파일: `/workspace/unitree_mujoco/simulate_python/config.py`

```python
ROBOT = "go2"           # 로봇 모델: "go2", "b2", "b2w", "h1", "go2w", "g1"
ROBOT_SCENE = "..."     # 시뮬레이션 씬 파일
DOMAIN_ID = 1           # DDS 도메인 ID (시뮬레이션: 1, 실제 로봇: 0)
INTERFACE = "lo"        # 네트워크 인터페이스 (시뮬레이션: "lo")
USE_JOYSTICK = 0        # 조이스틱 사용 여부 (Docker에서는 0)
```

## 종료 방법

### 시뮬레이터 종료

- 시뮬레이터 터미널에서 `Ctrl+C`를 눌러 종료합니다.

### 컨테이너 종료

```bash
# 컨테이너 ID 확인
docker ps --filter "label=devcontainer.local_folder=$(pwd)" --format "{{.ID}}"

# 컨테이너 정지
docker stop <CONTAINER_ID>

# 컨테이너 삭제 (필요 시)
docker rm <CONTAINER_ID>
```

### VS Code 사용 시

- 좌하단 `><` 아이콘을 클릭하고 **Reopen Folder Locally**를 선택하면 컨테이너에서 빠져나옵니다.
- 컨테이너를 완전히 삭제하려면 Docker Desktop에서 해당 컨테이너를 삭제합니다.

## 프로젝트 구조

```
go2_under_docker/
├── .devcontainer/
│   ├── devcontainer.json    # devcontainer 설정 (VNC, 포트 매핑 등)
│   ├── Dockerfile           # Ubuntu 22.04 + 시스템 의존성
│   └── post-create.sh       # 자동 설치 스크립트
├── .gitignore
├── README.md
└── unitree_mujoco/          # (컨테이너 생성 시 자동 클론)
    ├── simulate/            # C++ 시뮬레이터
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
