#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
source "$HOME/.cargo/env"

LIB_FEATURES=""
BENCH_FEATURES="ext"
POPCNT_SUFFIX=""
CPU_SUFFIX=""
TARGET_CPU="native"

for arg in "$@"; do
    case "$arg" in
        --scalar-popcnt)
            LIB_FEATURES="-F scalar-popcnt"
            BENCH_FEATURES="ext,scalar-popcnt"
            POPCNT_SUFFIX="_scalar_popcnt"
            ;;
        --simd-popc)
            LIB_FEATURES="-F simd-popc"
            BENCH_FEATURES="ext,simd-popc"
            POPCNT_SUFFIX="_simd_popc"
            ;;
        --icelake) TARGET_CPU="icelake-server"; CPU_SUFFIX="_icelake" ;;
        --zen)     TARGET_CPU="znver2";         CPU_SUFFIX="_zen" ;;
    esac
done

SUFFIX="${CPU_SUFFIX}${POPCNT_SUFFIX}"

# Compile the library to assembly with release optimizations
RUSTFLAGS="-C target-cpu=$TARGET_CPU --emit asm" cargo build -r -p quadrank --lib $LIB_FEATURES 2>&1

# Find the generated .s file
ASM_FILE=$(find target/release/deps -name 'quadrank-*.s' -newer Cargo.toml | head -1)

if [ -z "$ASM_FILE" ]; then
    echo "No .s file found. Try: cargo clean && ./scripts/dump_asm.sh"
    exit 1
fi

echo "Full assembly: $ASM_FILE"

# Extract BiRank16-related functions
grep -A 200 'BinaryBlock16.*rank\|rank.*BinaryBlock16' "$ASM_FILE" > "birank16_asm${SUFFIX}.s" 2>/dev/null || true

# Also dump from the bench binary (where rank_unchecked is inlined)
RUSTFLAGS="-C target-cpu=$TARGET_CPU" cargo build -r --example bench -F "$BENCH_FEATURES" 2>&1
objdump -d -M intel --no-show-raw-insn target/release/examples/bench \
    | awk '/bench_one_binary.*BinaryBlock16/{found=1} found{print} found && /^$/{count++} count>2{found=0;count=0}' \
    > "birank16_bench_asm${SUFFIX}.s" 2>/dev/null || true

echo "Extracted assembly written to:"
echo "  birank16_asm${SUFFIX}.s       (from library)"
echo "  birank16_bench_asm${SUFFIX}.s (from bench binary, inlined)"
echo ""
echo "Look for popcnt instructions:"
grep -c 'popcnt' "birank16_asm${SUFFIX}.s" 2>/dev/null && echo "  ^ in birank16_asm${SUFFIX}.s" || true
grep -c 'popcnt' "birank16_bench_asm${SUFFIX}.s" 2>/dev/null && echo "  ^ in birank16_bench_asm${SUFFIX}.s" || true
