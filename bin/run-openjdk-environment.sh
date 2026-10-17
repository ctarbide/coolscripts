#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
PATH_PRESET=${PATH_PRESET:-${JAVA_HOME}/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin}
if [ ! -x "${JAVA_HOME}/bin/java" ]; then
    die 1 "Error, \"${JAVA_HOME}/bin/java\" does not exist."
fi
exec env "JAVA_HOME=${JAVA_HOME}" \
    PATH="${PATH_PREFIX:+${PATH_PREFIX}:}${PATH_PRESET}${PATH_SUFFIX:+:${PATH_SUFFIX}}" \
    "$@"
