#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
exec perl -lne'next unless m{^\s*\d+\. ([hf][tps]+://.*)}; print($1)' -- "$@" |
    perl -lne's,#.+$,,; print(qq{\047${_}\047})' | sort -u
