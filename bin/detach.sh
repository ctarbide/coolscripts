#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
[ -t 0 ] || die 1 "what?"
exec 0>&- 1>&- 2>&-
exec sh -c '"$@" &' -- "$@"
