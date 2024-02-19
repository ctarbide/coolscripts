#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
filter(){
    perl -lne's,^\047(.*)\047$,${1},; s,\047,%27,g; next if m{\?$}; print' -- "$@"
}
if [ -f not-found ]; then
    if [ ! -f not-found.sorted -o not-found -nt not-found.sorted ]; then
        perl -lne's,^--2[\d\-: ]+--\s+,,; next unless m{^[\042\047]?(\w+://.*?)[\042\047]?$}; print($1)' -- not-found |
            sort -u > not-found.sorted
    fi
    filter "$@" | comm -23 - not-found.sorted
else
    filter "$@"
fi
