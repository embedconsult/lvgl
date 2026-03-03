#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/crystal"
OUTPUT_LIB="$BUILD_DIR/liblvgl.so"

mkdir -p "$BUILD_DIR"

mapfile -t SOURCES < <(find "$ROOT_DIR/src" -type f -name '*.c' | sort)

clang \
  -shared \
  -fPIC \
  -O2 \
  -fuse-ld=lld \
  -I"$ROOT_DIR" \
  -I"$ROOT_DIR/src" \
  -DLV_CONF_SKIP=1 \
  -DLV_USE_TEST=1 \
  -DLV_USE_SDL=1 \
  -DLV_USE_SNAPSHOT=1 \
  -DLV_USE_COLOR_FILTER=1 \
  -DLV_USE_LINUX_FBDEV=1 \
  -DLV_USE_EVDEV=1 \
  -DLV_LINUX_FBDEV_RENDER_MODE=LV_DISPLAY_RENDER_MODE_PARTIAL \
  "${SOURCES[@]}" \
  -o "$OUTPUT_LIB"

echo "Built $OUTPUT_LIB with TEST, SNAPSHOT, SDL, COLOR_FILTER, FBDEV and EVDEV support"
