#!/bin/sh
exec hexdump \
    -e '"%08_ax  "' \
    -e '8/1 "%02x "' \
    -e '"  |"' \
    -e '8/1 "%_p"' \
    -e '"|\n"' \
    -e '"%08_Ax\n"' \
    "$@"
