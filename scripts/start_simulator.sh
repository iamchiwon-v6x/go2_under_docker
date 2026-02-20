#!/bin/bash
# Unitree Go2 MuJoCo 시뮬레이터 실행 스크립트

export DISPLAY=:1
export XAUTHORITY=/home/vscode/.Xauthority
export LIBGL_ALWAYS_SOFTWARE=1

cd /workspace/sdk/unitree_mujoco/simulate_python
echo "=== Go2 MuJoCo 시뮬레이터 시작 ==="
echo "브라우저에서 http://localhost:6080 으로 확인 (비밀번호: unitree)"
echo "종료: Ctrl+C"
echo ""
python3 unitree_mujoco.py
