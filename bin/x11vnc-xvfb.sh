#!/bin/sh

# usage example: RESOLUTION=1912x1054x24 x11vnc-xvfb.sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

if [ x"${1:-}" = xstop ]; then
    which killall >/dev/null || die 1 "error: command not found: killall"
    set +e
    killall x11vnc
    killall Xvfb
    exit 0
fi

type socat >/dev/null 2>&1 || die 1 "error: command not found: socat"
type xrdb >/dev/null 2>&1 || die 1 "error: command not found: xrdb"
type Xvfb >/dev/null 2>&1 || die 1 "error: command not found: Xvfb"
type x11vnc >/dev/null 2>&1 || die 1 "error: command not found: x11vnc"

resolution=${RESOLUTION:-1280x900x24}

is_display_up(){
    xrdb -display "${1}" -query -all >/dev/null 2>&1
}

display_number=1

display=:${display_number}
display_tcp_port=$((5900+display_number))

# start Xvfb
if ! is_display_up "${display}"; then
    # display available, use it
    echo "starting Xvfb"
    Xvfb "${display}" +extension RANDR -screen 0 "${resolution}" &
    cnt=30
    echo -n "waiting for Xvfb "
    while [ "${cnt}" -gt 0 ] && ! is_display_up "${display}"; do
        echo -n '.'
        sleep .1
        cnt=$((cnt-1))
    done
    echo
    echo
    if [ "${cnt}" -eq 0 ]; then
        die 1 "error: failed to start Xvfb"
    fi
fi

# start x11vnc
if ! socat /dev/null "tcp:127.0.0.1:${display_tcp_port}" >/dev/null 2>&1; then
    echo "starting x11vnc"
    nohup x11vnc -display "${display}" -N -repeat -forever -nopw -listen 127.0.0.1 -xkb -loop &
    echo
fi

echo ''
echo 'Xvfb and x11vnc should now be running'
echo ''
echo 'vncview usage (tigervnc options):'
echo ''
echo "    vncviewer -FullScreen 127.0.0.1:${display_number}"
echo "    vncviewer -PreferredEncoding raw -NoJpeg 127.0.0.1:${display_number}"
echo ''
echo ''
echo 'other usage examples:'
echo ''
echo "    DISPLAY=${display} xterm &"
echo "    DISPLAY=${display} jwm &"
echo "    DISPLAY=${display} vtwm &"
echo ''
echo ''

echo "all done for ${0##*/}"
