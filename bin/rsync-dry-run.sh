#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
rsync --dry-run "$@"
echo 'confirm? (type "yes" to confirm)'
read ans
test "x${ans}" = xyes || die 1 "aborting"
exec rsync "$@"
