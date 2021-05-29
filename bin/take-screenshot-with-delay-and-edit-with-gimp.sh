#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -ge 1 ] || die 1 "usage: ${0##*/} seconds [--window|--area]"

which gimp >/dev/null || die 1 "error: program not found: gimp"
which gnome-screenshot >/dev/null || die 1 "error: program not found: gnome-screenshot"

perl -le'exit($ARGV[0] !~ m{^[1-9]\d*$})' -- "${1}" || die 1 "invalid input"

cd "${HOME}"

delay=$1
shift

output=`date +'Screenshot_from_%Y-%m-%d_%H-%M-%S.png'`

sleep "${delay}"

gnome-screenshot --file="${output}" "$@"

exec gimp "${output}"
