#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

LC_ALL=C
export LC_ALL

glob_has_file(){
    perl -le'exit(0) for grep {-f} glob($ARGV[0]); exit(1)' "${1}"
}

if [ "$#" -le 0 ]; then
    if glob_has_file "${HOME}/Downloads/Pictures/Screenshot_*.png"; then
        set -- ~/Downloads/Pictures/Screenshot_*.png
    fi
else
    for i in "$@"; do
        if ! perl -le'exit($ARGV[0] !~ m{^ 2 \d{3} $}x)' -- "${i}"; then
            die 1 "error: invalid argument, must be a year"
        fi
    done
    years=$@
    set -- # clear $@
    for i in $years; do
        if glob_has_file "${HOME}/Downloads/Pictures/${i}/Screenshot_*.png"; then
            set -- "$@" ~/Downloads/Pictures/"${i}"/Screenshot_*.png
        fi
    done
fi

if [ "$#" -le 0 ]; then
    die 1 "error: no files to show"
fi

exec feh-smart.sh "$@"
