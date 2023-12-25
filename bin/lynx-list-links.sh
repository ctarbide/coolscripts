#!/bin/sh
set -eu
user_agent=${USER_AGENT:-'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'}
for i in "$@"; do
    echo
    echo "input args: ${i}"
    echo
    set -x
    lynx --dump --listonly --image_links -useragent="${user_agent}" "${i}"
    set +x
done
