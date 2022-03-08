#!/bin/sh
set -eu
# TODO: DRY, see ~/.zshrc
PIPEWIRE_RUNTIME_DIR="/tmp/pipewire-`id -u`"
export PIPEWIRE_RUNTIME_DIR
mkdir -p "${PIPEWIRE_RUNTIME_DIR}"
exec pipewire
