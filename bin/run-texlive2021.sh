#!/bin/sh
set -eu
TEXLIVE_HOME=${HOME}/Ephemeral/texlive2021
if [ -d "${TEXLIVE_HOME}/bin/x86_64-linux" ]; then
    if ! perl -e'do { exit 0 if $_ eq qq{$ENV{TEXLIVE_HOME}/bin/x86_64-linux} } for split(q{:},$ENV{PATH}); exit 1'; then
        PATH=${TEXLIVE_HOME}/bin/x86_64-linux:${PATH}
        export PATH
    fi
    exec "$@"
else
    echo "ERROR: could not find texlive installation at \"${TEXLIVE_HOME}\"" 1>&2
fi
