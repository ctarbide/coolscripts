#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

unset TMUX

if [ -n "${1:-}" ]; then
    test -d "${1}" || die 1 "error: \"${1}\" is not a directory"
    cd "${1}"
fi

thisdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`

if [ -n "${2:-}" ]; then
    sess=${2}
else
    sess=${thisdir##*/}
    sess=${sess:-/}
fi


# tmux does not allow '.' on a session name
sess=`echo "${sess}" | sed 's,\.,_,g'`

tmux new-session -d -s "${sess}"
tmux send-keys -t "${sess}:0" "cd '${thisdir}'" C-m clear C-m
tmux rename-window -t "${sess}:0" 'home'
tmux switch-client -t "${sess}"
