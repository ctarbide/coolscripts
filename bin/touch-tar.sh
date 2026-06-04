#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
for arg; do
    case "${arg}" in
        *.tar.*)
            oldest_entry=`cat.sh "${arg}" | tar -tvf - | LC_ALL=C sort -k 4,5 | tail -1`
            if ! echo "${oldest_entry}" | perl -ne'exit 0 if m{^[drwxst\-]+ \s+ \w+/\w+ \s+ \d+ \s+ 2[\d-]{9} \s+ [\d:]+ \s}xi; exit 1'; then
                die 1 "Error, failed to parse \"${oldest_entry}\""
            fi
            date_hour=`perl -sle'print $1 if $s =~ m{^[drwxst\-]+ \s+ \w+/\w+ \s+ \d+ \s+ (2[\d-]{9} \s+ [\d:]+) \s}xi' -- -s="${oldest_entry}"`
            touch -d "${date_hour}" "${arg}"
            ;;
    esac
done
