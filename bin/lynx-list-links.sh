#!/bin/sh
set -eu
user_agent=${USER_AGENT:-'Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0'}
echo "input args: $@"
echo
exec lynx --dump --listonly --image_links -useragent="${user_agent}" "$@"
