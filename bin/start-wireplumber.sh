#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ x"${PIPEWIRE_RUNTIME_DIR:-}" = x ]; then
    die 1 "Error, PIPEWIRE_RUNTIME_DIR environment variable not set."
fi
exec wireplumber
