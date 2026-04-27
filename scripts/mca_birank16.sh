#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

POPCNT_SUFFIX=""
CPU_SUFFIX=""
MCPU="icelake-server"

for arg in "$@"; do
    case "$arg" in
        --scalar-popcnt) POPCNT_SUFFIX="_scalar_popcnt" ;;
        --simd-popc)     POPCNT_SUFFIX="_simd_popc" ;;
        --icelake)       CPU_SUFFIX="_icelake"; MCPU="icelake-server" ;;
        --zen)           CPU_SUFFIX="_zen";     MCPU="znver2" ;;
    esac
done

SUFFIX="${CPU_SUFFIX}${POPCNT_SUFFIX}"

llvm-mca \
    -mcpu="$MCPU" \
    -iterations=10000 \
    -bottleneck-analysis \
    -resource-pressure \
    "birank16_rank${SUFFIX}.s"
