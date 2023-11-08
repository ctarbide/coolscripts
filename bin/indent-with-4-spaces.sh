#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
command -v astyle >/dev/null || die 1 "Error, command 'astyle' not found."
exec astyle -n -s4 --style=k/r -xB -j \
    --pad-oper --pad-comma --break-blocks --pad-header --unpad-paren \
    --indent-after-parens \
    --min-conditional-indent=3 \
    --delete-empty-lines \
    --align-pointer=name \
    --align-reference=name \
    "$@"
