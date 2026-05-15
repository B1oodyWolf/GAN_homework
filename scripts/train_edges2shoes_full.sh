#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DATA_ROOT="${1:-$ROOT_DIR/datasets/edges2shoes}"

if [[ -n "${CONDA_PREFIX:-}" ]]; then
  export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:${LD_LIBRARY_PATH:-}"
fi

python train.py \
  --dataroot "$DATA_ROOT" \
  --name edges2shoes_pix2pix_full_bs4 \
  --model pix2pix \
  --direction AtoB \
  --n_epochs 5 \
  --n_epochs_decay 0 \
  --batch_size 4 \
  --lr 0.0002 \
  --num_threads 4 \
  --print_freq 500 \
  --save_latest_freq 5000 \
  --save_epoch_freq 5
