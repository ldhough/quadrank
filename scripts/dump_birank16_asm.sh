#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
source "$HOME/.cargo/env"

FEATURES=""
POPCNT_SUFFIX=""
CPU_SUFFIX=""
TARGET_CPU=""

for arg in "$@"; do
    case "$arg" in
        --scalar-popcnt) FEATURES="-F scalar-popcnt"; POPCNT_SUFFIX="_scalar_popcnt" ;;
        --simd-popc)     FEATURES="-F simd-popc";    POPCNT_SUFFIX="_simd_popc" ;;
        --icelake)       TARGET_CPU="icelake-server"; CPU_SUFFIX="_icelake" ;;
        --zen)           TARGET_CPU="znver2";         CPU_SUFFIX="_zen" ;;
    esac
done

SUFFIX="${CPU_SUFFIX}${POPCNT_SUFFIX}"
OUT="birank16_rank${SUFFIX}.s"

if [ -n "$TARGET_CPU" ]; then
    export RUSTFLAGS="-C target-cpu=$TARGET_CPU"
fi

{
    echo ".intel_syntax noprefix"
    cargo asm -p quadrank --lib birank16_rank $FEATURES 2>/dev/null
} > "$OUT"

echo "Written to $OUT"
echo ""
cat "$OUT"
