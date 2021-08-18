#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

if [ -n "${1:-}" ]; then
    test -d "${1}" || die 1 "error: \"${1}\" is not a directory"
    cd "${1}"
    thisdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`
else
    thisdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`
fi

new_window_at(){
    name=$1
    where=$2
    tmux new-window -t ":" -n "${name}"
    tmux send-keys -t "${name}" 'cd '"${where}" C-m clear C-m
}

# organize windows numbers before creating a new one
tmux move-window -r

new_window_at "${thisdir##*/}-$$" "${thisdir}"
