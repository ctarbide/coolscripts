#!/bin/sh
set -eu
NAME=${NAME:-unnamed}
# seq 101 116 | xargs | sed 's,1\([0-9]\+\),a\1,g'
# seq 101 116 | xargs | sed 's@1\([0-9]\+\)@0x${a\1},@g'
# cat c-hexify.sh | NAME=a ./c-hexify.sh | gcc -Da_LAST_ITEM=,0 -ansi -pedantic -Wall -Wextra -x c -c -o out.o -
echo "const char ${NAME}[] = {"
first=
od -v -A n -t x1 -w16 | while read a01 a02 a03 a04 a05 a06 a07 a08 a09 a10 a11 a12 a13 a14 a15 a16; do
    out="  ${first}0x${a01}, 0x${a02}, 0x${a03}, 0x${a04}, 0x${a05}, 0x${a06}, 0x${a07}, 0x${a08}, 0x${a09}, 0x${a10}, 0x${a11}, 0x${a12}, 0x${a13}, 0x${a14}, 0x${a15}, 0x${a16}"
    first=,
    try=${out%, 0x}
    if [ "${out}" != "${try}" ]; then
        # maybe last line
        out=${try}
        try=${out%, 0x}
        while [ "${out}" != "${try}" ]; do
            out=${try}
            try=${out%, 0x}
        done
    fi
    echo "${out}"
done
echo "${NAME}_LAST_ITEM};"
