#!/bin/sh

# TeX Live installation procedure:
#
#     # setup prefix
#     TEXLIVE_INSTALL_PREFIX=${HOME}/Ephemeral/texlive`date "+%Y"`
#     export TEXLIVE_INSTALL_PREFIX
#
#     # cd to texlive distribution
#
#     ./install-tl -portable -scheme scheme-full -gui expert
#
# This is just a hint and what I normally do, refer to official
# documentation at:
#
# - https://tug.org/texlive/doc/texlive-en/texlive-en.html#installation
#
#

set -eu

TEXLIVE_HOME=${HOME}/Ephemeral/texlive2022

if [ -d "${TEXLIVE_HOME}/bin/x86_64-linuxmusl" ]; then
    if ! perl -e'do { exit 0 if $_ eq qq{$ENV{TEXLIVE_HOME}/bin/x86_64-linuxmusl} } for split(q{:},$ENV{PATH}); exit 1'; then
        PATH=${TEXLIVE_HOME}/bin/x86_64-linuxmusl:${PATH}
        export PATH
    fi
    exec "$@"
elif [ -d "${TEXLIVE_HOME}/bin/x86_64-linux" ]; then
    if ! perl -e'do { exit 0 if $_ eq qq{$ENV{TEXLIVE_HOME}/bin/x86_64-linux} } for split(q{:},$ENV{PATH}); exit 1'; then
        PATH=${TEXLIVE_HOME}/bin/x86_64-linux:${PATH}
        export PATH
    fi
    exec "$@"
else
    echo "ERROR: could not find texlive installation at \"${TEXLIVE_HOME}\"" 1>&2
fi
