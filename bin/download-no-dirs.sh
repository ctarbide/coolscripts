#!/bin/sh
set -eu
LC_ALL=C
export LC_ALL
exec perl -l0 -pe1 | xargs -r0 echo wget-with-agent.sh -T 15 -cN
