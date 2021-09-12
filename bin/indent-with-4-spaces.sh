#!/bin/sh
set -eu
cfg=${HOME}/.bcpp.cfg
test -f "${cfg}" || echo > "${cfg}"
exec bcpp -bcl -s -i 4 "$@"
