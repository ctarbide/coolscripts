#!/bin/sh
set -eu
PATH_PRESET=${PATH_PRESET:-/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin}
exec env - \
    PATH="${PATH_PREFIX:+${PATH_PREFIX}:}${PATH_PRESET}${PATH_SUFFIX:+:${PATH_SUFFIX}}" \
    USER="${USER:-}" \
    HOME="${HOME:-}" \
    LOGNAME="${LOGNAME:-}" \
    LANG="${LANG:-en_US.UTF-8}" \
    "$@"
