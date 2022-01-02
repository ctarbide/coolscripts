#!/bin/sh
set -eu
exec env - \
    PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin" \
    USER="${USER:-}" \
    HOME="${HOME:-}" \
    LOGNAME="${LOGNAME:-}" \
    LANG=en_US.UTF-8 \
    "$@"
