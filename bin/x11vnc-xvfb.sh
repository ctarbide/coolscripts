#!/bin/sh

set -eu #x

# start Xvfb
if ! xrdb -display :1 -query -all >/dev/null 2>&1; then
    # display 1 available, use it
    Xvfb :1 +extension RANDR -screen 0 1600x1000x24 &
    echo 'sleeping 5 seconds just to let Xvfb light up ...'
    sleep 5
fi

# start x11vnc
if ! lsof -i4:5901 -n >/dev/null 2>&1; then
    x11vnc=${HOME}/Ephemeral/build/x11vnc-for-centos7/x11vnc-0.9.13/x11vnc/x11vnc
    nohup "${x11vnc}" -display :1 -N -repeat -forever -nopw -listen 127.0.0.1 -xkb -loop &
fi

echo
echo 'now just do: vncviewer -FullScreen 127.0.0.1:1'
echo 'or (for better viewing quality): vncviewer -PreferredEncoding raw -NoJpeg 127.0.0.1:1'
echo 'maybe too: DISPLAY=:1 xterm &'
echo
echo
echo "all done for ${0##*/}"
