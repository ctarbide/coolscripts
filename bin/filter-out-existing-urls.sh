#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
filter(){
    perl -lne'next if m{\?|/$}; print' -- "$@" |
        perl -MURI::Escape -lne'next if m{%} and m{^\w+://(.*)$} and -f uri_unescape($1); print' |
        perl -lne'next if m{^\w+://(.*)$} and -f $1; print'
}
if [ -f not-found ]; then
    if [ ! -f not-found.sorted -o not-found -nt not-found.sorted ]; then
        perl -lne'next unless m{^\w+://}; print' -- not-found | sort -u > not-found.sorted
    fi
    filter "$@" | comm -23 - not-found.sorted
else
    filter "$@"
fi
