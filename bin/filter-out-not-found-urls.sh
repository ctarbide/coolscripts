#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
filter(){
    perl -lne'next if m{\?|/$}; print' -- "$@"
}
if [ -f not-found ]; then
    if [ ! -f not-found.sorted -o not-found -nt not-found.sorted ]; then
        perl -lne's,^--2[\d\-: ]+--\s+,,; next unless m{^\w+://}; print' -- not-found |
            sort -u > not-found.sorted
    fi
    filter "$@" | comm -23 - not-found.sorted
else
    filter "$@"
fi
