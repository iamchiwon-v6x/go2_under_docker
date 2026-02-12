# Unitree Go2 MuJoCo Simulator

[![한국어](https://img.shields.io/badge/lang-한국어-blue.svg)](README.ko.md)

A MuJoCo simulation environment for the Unitree Go2 quadruped robot. Uses devcontainer to set up an Ubuntu environment inside Docker, with VNC for viewing the simulator display.

<img width="1492" height="792" alt="image" src="https://github.com/user-attachments/assets/c41d2ea3-71a4-4088-a117-975c6cef1497" />

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- One of the following:
  - [VS Code](https://code.visualstudio.com/) + [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
  - [devcontainer CLI](https://github.com/devcontainers/cli) (`npm install -g @devcontainers/cli`)

## Setup

### Option 1: VS Code (Recommended)

1. Clone this repository.
   ```bash
   git clone https://github.com/iamchiwon-v6x/go2_under_docker.git
   cd go2_under_docker
   ```

2. Open the folder in VS Code.
   ```bash
   code .
   ```

3. Click the `><` icon in the bottom-left corner and select **Reopen in Container**.

4. The container build and dependency installation will run automatically (about 5–10 minutes on first run).

### Option 2: devcontainer CLI

```bash
git clone https://github.com/iamchiwon-v6x/go2_under_docker.git
cd go2_under_docker
devcontainer up --workspace-folder .
```

Once the container is running, open a shell:

```bash
devcontainer exec --workspace-folder . bash
```

> **Tip**: You need two terminals for testing (one for the simulator, one for the control program). Run the command above in two separate terminal tabs.

### Auto-Installed Dependencies

When the container is created, `post-create.sh` automatically installs:

| Package | Description |
|---------|-------------|
| [unitree_mujoco](https://github.com/unitreerobotics/unitree_mujoco) | MuJoCo-based Unitree robot simulator |
| [cyclonedds 0.10.2](https://github.com/eclipse-cyclonedds/cyclonedds) | DDS communication library (built from source) |
| [unitree_sdk2_python](https://github.com/unitreerobotics/unitree_sdk2_python) | Unitree SDK2 Python bindings |
| mujoco, pygame, numpy, opencv-python-headless | Python simulator dependencies |

## Quick Start

### 1. Start the Simulator

In the container terminal:

```bash
./scripts/start_simulator.sh
```

### 2. View via VNC

Open **http://localhost:6080** in your browser to access the VNC desktop.
- Password: `unitree`
- If you see the Go2 robot in the MuJoCo window, everything is working.

### 3. Run a Control Program

With the simulator running, open a **separate terminal** and run a control program.

In VS Code, press `Ctrl+Shift+~` to open a new terminal. With devcontainer CLI, run `devcontainer exec --workspace-folder . bash` in a new terminal tab.

```bash
# Basic test: applies 1Nm torque to each motor and prints state
./scripts/run_test.sh

# Go2 stand up / lie down example
./scripts/stand_go2.sh
```

### Script Reference

| Script | Description |
|--------|-------------|
| `scripts/start_simulator.sh` | Launch the MuJoCo simulator |
| `scripts/run_test.sh` | Basic motor test (requires simulator) |
| `scripts/stand_go2.sh` | Go2 stand-up example (requires simulator) |

## Simulator Configuration

Config file: `unitree_mujoco/simulate_python/config.py`

```python
ROBOT = "go2"           # Robot model: "go2", "b2", "b2w", "h1", "go2w", "g1"
ROBOT_SCENE = "..."     # Simulation scene file
DOMAIN_ID = 1           # DDS domain ID (simulation: 1, real robot: 0)
INTERFACE = "lo"        # Network interface (simulation: "lo")
USE_JOYSTICK = 0        # Joystick usage (0 in Docker)
```

## Shutting Down

### Stop the Simulator

Press `Ctrl+C` in the simulator terminal.

### VS Code

- Click the `><` icon in the bottom-left → select **Reopen Folder Locally** to exit the container.
- To completely remove the container, delete it from Docker Desktop.

### devcontainer CLI

```bash
# Find the container ID
docker ps --filter "label=devcontainer.local_folder=$(pwd)" --format "{{.ID}}"

# Stop the container
docker stop <CONTAINER_ID>

# Remove the container (optional)
docker rm <CONTAINER_ID>
```

## Project Structure

```
go2_under_docker/
├── .devcontainer/
│   ├── devcontainer.json    # Devcontainer config (VNC, port mapping, env vars)
│   ├── Dockerfile           # Ubuntu 22.04 + system dependencies
│   ├── post-create.sh       # Auto-install script
│   └── cyclonedds.xml       # CycloneDDS communication config
├── scripts/
│   ├── start_simulator.sh   # Launch simulator
│   ├── run_test.sh          # Basic motor test
│   └── stand_go2.sh         # Go2 stand-up example
├── .gitignore
├── README.md                # English documentation
├── README.ko.md             # Korean documentation (한국어)
└── unitree_mujoco/          # (auto-cloned on container creation)
    ├── simulate_python/     # Python simulator (default)
    ├── unitree_robots/      # Robot MJCF model files
    ├── terrain_tool/        # Terrain generation tool
    └── example/             # Example programs (stand_go2, etc.)
```

## References

- [unitree_mujoco](https://github.com/unitreerobotics/unitree_mujoco) — Original simulator repository
- [unitree_sdk2_python](https://github.com/unitreerobotics/unitree_sdk2_python) — Python SDK
- [MuJoCo Documentation](https://mujoco.readthedocs.io/en/stable/overview.html)
- [Unitree Developer Documentation](https://support.unitree.com/home/zh/developer)
