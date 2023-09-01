#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
cfg=${HOME}/.bcpp.cfg
test -f "${cfg}" || echo > "${cfg}"
exec 2>/dev/null
# exec bcpp -ylcnc -tbcl -bcl -nbbi -nbi -t "$@"
command -v astyle >/dev/null || die 1 "Error, command 'astyle' not found."
exec astyle -n -T8 --style=k/r -xB -j \
    --pad-oper --pad-comma --break-blocks --pad-header --unpad-paren \
    --indent-after-parens \
    --min-conditional-indent=3 \
    --delete-empty-lines \
    --align-pointer=name \
    --align-reference=name \
    "$@"
