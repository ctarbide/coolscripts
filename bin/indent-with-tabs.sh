#!/bin/sh
set -eu
cfg=${HOME}/.bcpp.cfg
test -f "${cfg}" || echo > "${cfg}"
exec 2>/dev/null
# exec bcpp -ylcnc -tbcl -bcl -nbbi -nbi -t "$@"
exec astyle -n -T8 --style=k/r -xB -j \
    --pad-oper --pad-comma --break-blocks --pad-header --unpad-paren \
    --indent-after-parens \
    --min-conditional-indent=3 \
    --delete-empty-lines \
    --align-pointer=name \
    --align-reference=name \
    "$@"
