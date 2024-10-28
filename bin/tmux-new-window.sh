#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# usage: tmux-new-window.sh dir [name]

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

exact_name_to_id_all_sessions(){
    tmux lsw -a -F '#{session_name}/#{window_name}/#{window_id}' | perl -F/ -slane'print$F[2] if $F[1] eq $name' -- -name="${1}"
}

exact_name_to_id_current_session(){
    tmux lsw -F '#{window_name}/#{window_id}' | perl -F/ -slane'print$F[1] if $F[0] eq $name' -- -name="${1}"
}

new_window_at(){
    name=$1
    where=$2
    wid=`exact_name_to_id_current_session "${name}"`
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
