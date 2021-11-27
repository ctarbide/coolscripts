#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
wait=${WAIT:-1}
unset WAIT
set -- echo wget-with-agent.sh -T 15 -cxN --no-remove-listing
if [ x"${wait}" != x0 ]; then
    set -- "$@" --wait "${wait}" --random-wait
fi
exec perl -l0 -pe1 | xargs -r0 "$@"
