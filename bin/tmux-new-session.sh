#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# usage: tmux-new-session.sh dir [name]

targetdir=

if [ -n "${1:-}" ]; then
    if [ -d "${1}" ]; then
        targetdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${1}"`
    elif [ -f "${1}" ]; then
        targetdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${1}"`
        targetdir=${targetdir%/*}
    else
        die 1 "Error, first argument does not hint a directory."
    fi
else
    targetdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- .`
fi

where="${targetdir}"
cd "${targetdir}"

unset TMUX

if [ -n "${2:-}" ]; then
    sess=${2}
else
    sess=${where##*/}
    sess=${sess:-/}
fi


# tmux does not allow '.' on a session name
sess=`echo "${sess}" | sed 's,\.,_,g'`

tmux new-session -d -s "${sess}"
tmux send-keys -t "${sess}:0" "cd '${where}'" C-m clear C-m
tmux rename-window -t "${sess}:0" 'home'
tmux switch-client -t "${sess}"
