#!/bin/sh
set -eu
curl --head -sSL "$@" |
    perl -lne'next unless m{^(?: http | date | server | location | last-modified | content-type \s* : | content-length \s* : | \s )}xi; print'
