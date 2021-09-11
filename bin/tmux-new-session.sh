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

unset TMUX

sess=${thisdir##*/}

tmux new-session -d -s "${sess}"

tmux send-keys -t "${sess}:0" "cd '${thisdir}'" C-m clear C-m

tmux rename-window -t "${sess}:0" 'home'

tmux switch-client -t "${sess}"
