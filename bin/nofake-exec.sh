#!/bin/sh
set -eu
# generated from nofake-exec.nw
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ x"${ZSH_VERSION:-}" != x ]; then
    # let zsh behave like ash, ksh and other standard
    # shells when expanding parameters
    setopt sh_word_split
fi
tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){ u0Aa.sh | head -n"${1}" | perl -pe chomp; }
r0Aa(){ r0Aa.sh | head -n"${1}" | perl -pe chomp; }

temporary_file(){
    if command -v mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif command -v perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    elif command -v perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}

SRC_PREFIX=${SRC_PREFIX:-}
NOFAKE_SH=${NOFAKE_SH:-nofake.sh}
NOFAKE_SH_FLAGS=${NOFAKE_SH_FLAGS:-}

nargs= # nofake args
eargs= # exec args

for arg do
    if [ x"${arg}" = x-- ]; then shift; break; fi
    nargs="${nargs:+${nargs} }'${arg}'"
    shift # 'for' is synchronized with 'shift'
done

if [ x$# = x0 ]; then
    die 1 "Error, exec arguments are absent."
fi

for arg do eargs="${eargs:+${eargs} }'${arg}'"; done

eval "set -- ${nargs}"

opts=
chunks=
sources=
output=

while [ $# -gt 0 ]; do
    case "${1}" in
        -L*|--error) opts="${opts:+${opts} }'${1}'" ;;
        -R*) chunks="${chunks:+${chunks} }'${1}'" ;;

        -o|--output) output=${2}; shift ;;
        --output=*) output=${1#*=} ;;
        -o*) output=${1#??} ;;

        -) sources="${sources:+${sources} }'-'" ;;
        -*)
            ${ECHO} "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
        *) sources="${sources:+${sources} }'${SRC_PREFIX}${1}'" ;;
    esac
    shift
done

if [ x"${output}" = x ]; then
    output=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${output}'"
fi

eval "set -- ${opts} ${chunks} ${sources}"
${NOFAKE_SH} ${NOFAKE_SH_FLAGS} "$@" -o"${output}"
eval "set -- ${eargs} '${output}'"
exec "$@"
