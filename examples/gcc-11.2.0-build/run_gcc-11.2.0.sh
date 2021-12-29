#!/bin/sh

set -eu #x

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`

thisprog=${thispath##*/}
thisdir=${thispath%/*}

. "${thisdir}/config.inc.sh"
. "${thisdir}/config_gcc-11.2.0.inc.sh"

LANG=en_US.UTF-8
export LANG

is_path_element(){
    perl -e'do { exit(0) if $_ eq $ARGV[0] } for split(q{:}, $ENV{PATH}); exit(1)' -- "$@"
}

can_be_added_to_path(){
    test -d "${1}" && ! is_path_element "${1}"
}

is_ld_lib_path_element(){
    perl -e'do { exit(0) if $_ eq $ARGV[0] } for split(q{:}, $ENV{LD_LIBRARY_PATH}); exit(1)' -- "$@"
}

can_be_added_to_ld_lib_path(){
    test -d "${1}" && ! is_ld_lib_path_element "${1}"
}

if can_be_added_to_path "${PREFIX}/bin"; then
    PATH=${PREFIX}/bin:${PATH}
    export PATH
fi

if can_be_added_to_path "${GCC_PREFIX}/bin"; then
    PATH=${GCC_PREFIX}/bin:${PATH}
    export PATH
fi

if can_be_added_to_ld_lib_path "${PREFIX}/lib"; then
    LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH:-}
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
    export LD_LIBRARY_PATH
fi

if can_be_added_to_ld_lib_path "${PREFIX}/lib64"; then
    LD_LIBRARY_PATH=${PREFIX}/lib64:${LD_LIBRARY_PATH:-}
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
    export LD_LIBRARY_PATH
fi

if can_be_added_to_ld_lib_path "${GCC_PREFIX}/lib"; then
    LD_LIBRARY_PATH=${GCC_PREFIX}/lib:${LD_LIBRARY_PATH:-}
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
    export LD_LIBRARY_PATH
fi

if can_be_added_to_ld_lib_path "${GCC_PREFIX}/lib64"; then
    LD_LIBRARY_PATH=${GCC_PREFIX}/lib64:${LD_LIBRARY_PATH:-}
    LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
    export LD_LIBRARY_PATH
fi

# set CC and CXX

CC=${GCC_PREFIX}/bin/gcc
CXX=${GCC_PREFIX}/bin/g++

export CC CXX

# unset generic environment variables

unset BUILD_DIR
unset PREFIX
unset GCC_PREFIX

# unleash

exec "$@"
