#!/bin/sh
set -eu
exec find -type f -a '(' -name '*.[ch]' -o -name '*.el' -o -name '*.sh' ')' "$@"
