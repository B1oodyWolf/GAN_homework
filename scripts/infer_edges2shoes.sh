#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DATA_ROOT="${1:-$ROOT_DIR/datasets/edges2shoes}"
NUM_TEST="${NUM_TEST:-50}"

if [[ -n "${CONDA_PREFIX:-}" ]]; then
  export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:${LD_LIBRARY_PATH:-}"
fi

bash scripts/reconstruct_model.sh

python test.py \
  --dataroot "$DATA_ROOT" \
  --name edges2shoes_pix2pix_full_bs4 \
  --model pix2pix \
  --direction AtoB \
  --phase val \
  --num_test "$NUM_TEST" \
  --batch_size 1 \
  --num_threads 0 \
  --eval \
  --results_dir results
