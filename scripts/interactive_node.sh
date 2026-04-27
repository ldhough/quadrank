#!/usr/bin/env bash
set -euo pipefail

CORES="${1:-4}"
TIME="${2:-01:00:00}"
MEM="${3:-32G}"

srun -t "$TIME" -c "$CORES" --mem="$MEM" --pty bash
