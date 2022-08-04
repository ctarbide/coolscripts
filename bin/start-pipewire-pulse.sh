#!/bin/sh
set -eu

# TODO: DRY, see ~/.zshrc

PIPEWIRE_RUNTIME_DIR="/tmp/pipewire-`id -u`"
PULSE_RUNTIME_PATH="/tmp/pipewire-pulse-`id -u`"

# previously
# PULSE_SERVER=${PULSE_RUNTIME_PATH}/pulse/native

PULSE_SERVER=${PULSE_RUNTIME_PATH}/native

export PIPEWIRE_RUNTIME_DIR PULSE_RUNTIME_PATH PULSE_SERVER

mkdir -p \
    "${PIPEWIRE_RUNTIME_DIR}" \
    "${PULSE_RUNTIME_PATH}"

exec pipewire-pulse
