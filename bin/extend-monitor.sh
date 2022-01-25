#!/bin/sh
set -eu
leftmonitor=eDP1
rightmonitor=HDMI1
exec xrandr --output "${leftmonitor}" --left-of "${rightmonitor}"
