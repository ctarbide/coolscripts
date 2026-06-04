#!/bin/sh
set -eu
term=$1; shift
exec perl -wslne'$ln = ++$ln{$ARGV}; next unless m{(?:(?<=\W)|^)\Q${term}\E(?=\W|$)}; print(qq{${ARGV}:${ln}:${_}})' -- -term="${term}" "$@"
