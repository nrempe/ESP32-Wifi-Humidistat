#!/bin/zsh

set -euo pipefail

TOOLS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$TOOLS_DIR/.." && pwd)"
BUILD_ROOT="${TMPDIR:-/tmp}/esphome_build"
ESPHOME_BIN="$REPO_ROOT/.venv/bin/esphome"

COMMAND="${1:-compile}"
CONFIG_FILE="${2:-esphome/zone-a.yaml}"
CONFIG_BASENAME="$(basename "$CONFIG_FILE")"

if [[ ! -x "$ESPHOME_BIN" ]]; then
  if command -v esphome >/dev/null 2>&1; then
    ESPHOME_BIN="$(command -v esphome)"
  else
    echo "ESPHome was not found."
    echo "Install it in a local .venv or make 'esphome' available on your PATH."
    exit 1
  fi
fi

if [[ ! -f "$REPO_ROOT/$CONFIG_FILE" ]]; then
  echo "Config file not found: $REPO_ROOT/$CONFIG_FILE"
  exit 1
fi

rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT/esphome"

for yaml_file in "$REPO_ROOT"/esphome/*.yaml; do
  [[ -f "$yaml_file" ]] || continue
  cp "$yaml_file" "$BUILD_ROOT/esphome/"
done

if [[ -f "$REPO_ROOT/esphome/secrets.yaml" ]]; then
  cp "$REPO_ROOT/esphome/secrets.yaml" "$BUILD_ROOT/esphome/secrets.yaml"
else
  cp "$REPO_ROOT/esphome/secrets.example.yaml" "$BUILD_ROOT/esphome/secrets.example.yaml" >/dev/null 2>&1 || true
fi

cd "$BUILD_ROOT"
"$ESPHOME_BIN" "$COMMAND" "$BUILD_ROOT/$CONFIG_FILE"

if [[ "$COMMAND" == "compile" ]]; then
  echo
  echo "Build artifacts:"
  echo "  $BUILD_ROOT/.esphome/build/${CONFIG_BASENAME:r}/.pioenvs/${CONFIG_BASENAME:r}/firmware.bin"
  echo "  $BUILD_ROOT/.esphome/build/${CONFIG_BASENAME:r}/.pioenvs/${CONFIG_BASENAME:r}/firmware.factory.bin"
fi
