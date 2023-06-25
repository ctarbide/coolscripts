#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

if [ x"${PIPEWIRE_RUNTIME_DIR:-}" = x ]; then
    die 1 "Error, PIPEWIRE_RUNTIME_DIR environment variable not set."
fi

PULSE_RUNTIME_PATH="/tmp/pipewire-pulse-`id -u`"

# previously
# PULSE_SERVER=${PULSE_RUNTIME_PATH}/pulse/native

PULSE_SERVER=${PULSE_RUNTIME_PATH}/native

export PULSE_RUNTIME_PATH PULSE_SERVER

mkdir -p "${PULSE_RUNTIME_PATH}"

exec pipewire-pulse
