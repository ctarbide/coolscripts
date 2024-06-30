#!/bin/sh

# reference: https://ryan.himmelwright.net/post/scripting-tmux-workspaces/

set -eu

new_window_at(){
    session=$1
    name=$2
    where=$3
    tmux new-window -t "${session}:" -n "${name}"
    tmux send-keys -t "${name}" 'cd '"${where}" C-m clear C-m
}

if ! tmux ls | perl -F: -lane'exit 0 if $F[0] eq q{misc}}{exit(1)'; then
    tmux new-session -d -s misc
    tmux rename-window -t misc:0 'home'
    new_window_at misc aux ~/
    new_window_at misc TODO ~/Downloads/TODO/
fi

if ! tmux ls | perl -F: -lane'exit 0 if $F[0] eq q{mplayer}}{exit(1)'; then
    tmux new-session -d -s mplayer
    tmux rename-window -t mplayer:0 "mplayer"
    tmux send-keys -t mplayer:0.0 top C-m
    sh -c '
        wait(){ perl -le"select(undef,undef,undef,0.15)"; }
        wait; tmux send-keys -t mplayer:0.0 c;
        wait; tmux send-keys -t mplayer:0.0 z;
        tmux split-window -t mplayer:0.0 -h -l 30%;
        tmux split-window -t mplayer:0.0 -v -l 25%;
        tmux split-window -t mplayer:0.1 -h -l 35%;
    ' &
fi

exec tmux a
