#!/bin/sh
set -eu
cfg=${HOME}/.bcpp.cfg
test -f "${cfg}" || echo > "${cfg}"
exec 2>/dev/null
exec bcpp -ylcnc -tbcl -bcl -nbbi -nbi -t "$@"
