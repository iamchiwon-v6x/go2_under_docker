#!/bin/bash
# 테스트 프로그램 실행 (시뮬레이터가 실행 중이어야 함)
# 각 모터에 1Nm 토크를 인가하고 로봇 상태를 출력합니다.

cd /workspace/sdk/unitree_mujoco/simulate_python
echo "=== 테스트 프로그램 실행 ==="
echo "(시뮬레이터가 실행 중이어야 합니다)"
echo ""
python3 ./test/test_unitree_sdk2.py
