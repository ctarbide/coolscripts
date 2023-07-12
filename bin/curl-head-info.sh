#!/bin/sh
set -eu
echo
echo '**** input args: '"$@"
echo
curl --head -sSL "$@" |
    perl -lne'next unless m{^(?: http | date | server | location | last-modified | content-type \s* : | content-length \s* : | \s )}xi; print'
