#!/bin/sh
set -eu
user_agent=${USER_AGENT:-'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0'}
exec wget --no-check-certificate \
    --header='Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8"' \
    --header='Accept-Language: en-US,en;q=0.5' \
    --user-agent="${user_agent}" \
    "$@"
