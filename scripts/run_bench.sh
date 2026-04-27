#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

usage() {
    echo "Usage: $0 [--csv | --human] [--scalar-popcnt | --simd-popc] [--icelake | --zen] [THREADS]"
    echo "  --csv             show only CSV output"
    echo "  --human           show only human-readable output"
    echo "  --scalar-popcnt   scalar popcnt variant"
    echo "  --simd-popc       AVX-512 SIMD popcnt variant"
    echo "  --icelake         icelake-server build"
    echo "  --zen             znver2 build"
    echo "  THREADS           number of threads (default: 1)"
    exit 1
}

FORMAT=""
THREADS=1
POPCNT_SUFFIX=""
CPU_SUFFIX=""

for arg in "$@"; do
    case "$arg" in
        --csv)            FORMAT=csv ;;
        --human)          FORMAT=human ;;
        --scalar-popcnt)  POPCNT_SUFFIX="_scalar_popcnt" ;;
        --simd-popc)      POPCNT_SUFFIX="_simd_popc" ;;
        --icelake)        CPU_SUFFIX="_icelake" ;;
        --zen)            CPU_SUFFIX="_zen" ;;
        --help)           usage ;;
        *)                THREADS="$arg" ;;
    esac
done

SUFFIX="${CPU_SUFFIX}${POPCNT_SUFFIX}"
BIN="./target/release/examples/bench${SUFFIX}"

if [ ! -f "$BIN" ]; then
    echo "Binary not found: $BIN"
    echo "Build it with the matching flags via ./scripts/build_bench.sh"
    exit 1
fi

case "$FORMAT" in
    csv)   "$BIN" -b -j "$THREADS" 2>/dev/null ;;
    human) "$BIN" -b -j "$THREADS" 2>&1 >/dev/null ;;
    *)     "$BIN" -b -j "$THREADS" ;;
esac
