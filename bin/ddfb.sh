#!/bin/sh
set -eu
# ensure safe and quied dd usage, copying full blocks
exec dd iflag=fullblock "$@" 2>/dev/null
