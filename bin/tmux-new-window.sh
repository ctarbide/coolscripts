#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# usage: tmux-new-window.sh dir [name]

if [ -n "${1:-}" ]; then
    test -d "${1}" || die 1 "error: \"${1}\" is not a directory"
fi

targetdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${1:-.}"`

new_window_at(){
    name=$1
    where=$2
    wid=`tmux display-message -p -F '#{window_id}' -t "${name}"`
    if [ x"${wid}" = x ]; then
        tmux new-window -t ":" -n "${name}"
        tmux send-keys -t "${wid}" 'cd '"${where}" C-m clear C-m
    else
        die 1 "Error, window name \"${name}\" already exists." \
            "usage: tmux-new-window.sh dir [name]"
    fi
}

# organize windows numbers before creating a new one
tmux move-window -r

if [ -n "${2:-}" ]; then
    name=${2}
else
    name=${targetdir##*/}
    name=${name:-/}
fi

new_window_at "${name}" "${targetdir}"
