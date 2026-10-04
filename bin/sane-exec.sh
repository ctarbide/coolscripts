#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
if [ x"${TERM:-}" != x ]; then
    set -- TERM="${TERM}" "$@"
fi
PATH_PREFIX="${thisdir}" exec "${thisdir}/run-pristine-environment.sh" "$@"
