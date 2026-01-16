#!/bin/sh
set -eu
user_agent=${USER_AGENT:-'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'}
for i in "$@"; do
    echo
    echo "input args: ${i}"
    echo
    lynx --dump --listonly --image_links -useragent="${user_agent}" "${i}"
    if [ x"${WAIT:-}" != x ]; then
        perl -sle'select(undef,undef,undef,$wait);' -- -wait="${WAIT}"
    fi
done
