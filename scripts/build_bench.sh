#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
source "$HOME/.cargo/env"

FEATURES="ext"
POPCNT_SUFFIX=""
CPU_SUFFIX=""
TARGET_CPU=""

for arg in "$@"; do
    case "$arg" in
        --scalar-popcnt) FEATURES="ext,scalar-popcnt"; POPCNT_SUFFIX="_scalar_popcnt" ;;
        --simd-popc)     FEATURES="ext,simd-popc";     POPCNT_SUFFIX="_simd_popc" ;;
        --icelake)       TARGET_CPU="icelake-server";  CPU_SUFFIX="_icelake" ;;
        --zen)           TARGET_CPU="znver2";          CPU_SUFFIX="_zen" ;;
    esac
done

SUFFIX="${CPU_SUFFIX}${POPCNT_SUFFIX}"

if [ -n "$TARGET_CPU" ]; then
    export RUSTFLAGS="-C target-cpu=$TARGET_CPU"
fi

cargo build -r --example bench -F "$FEATURES"
if [ -n "$SUFFIX" ]; then
    cp target/release/examples/bench "target/release/examples/bench${SUFFIX}"
fi

echo "Binary at: ./target/release/examples/bench${SUFFIX}"
