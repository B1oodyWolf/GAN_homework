#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CKPT_DIR="$ROOT_DIR/checkpoints/edges2shoes_pix2pix_full_bs4"
MODEL_PATH="$CKPT_DIR/latest_net_G.pth"

if [[ -f "$MODEL_PATH" ]]; then
  echo "Model already exists: $MODEL_PATH"
  exit 0
fi

shopt -s nullglob
parts=("$CKPT_DIR"/latest_net_G.pth.part-*)
if [[ ${#parts[@]} -eq 0 ]]; then
  echo "No model parts found in $CKPT_DIR" >&2
  exit 1
fi

cat "${parts[@]}" > "$MODEL_PATH"
echo "Reconstructed model: $MODEL_PATH"
