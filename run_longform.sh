#!/usr/bin/env bash
set -euo pipefail

MODEL_ID="${MODEL_ID:-openbmb/VoxCPM2}"
PORT="${PORT:-7860}"

exec python app.py \
  --model-id "$MODEL_ID" \
  --server-port "$PORT" \
  "$@"
