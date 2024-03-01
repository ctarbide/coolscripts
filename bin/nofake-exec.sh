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

u0Aa(){
perl -le'
@map = map {chr} 48..57, 65..90, 97..122;
while (read(STDIN,$d,64)) {
    for $x (unpack(q{C*},$d)) {
        next if $x >= @map;
        print $map[$x];
    }
}' </dev/urandom |
    head -n"${1}" | perl -pe chomp; }

r0Aa(){
perl -le'
@map = map {chr} 48..57, 65..90, 97..122;
sub r{int(rand(scalar(@map)))}
for (;;) { print $map[r] }' |
    head -n"${1}" | perl -pe chomp; }

create_safe_file(){
    ( umask 0177; : >"${1}" )
}

temporary_file(){
    if command -v mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif command -v perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`"
        create_safe_file "${tmpfile}"
    elif command -v perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 10`"
        create_safe_file "${tmpfile}"
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}
normalize_arg(){
    head=
    tail=${1}
    acc=
    while true; do
        head=${tail%%\'*}
        tail=${tail#*\'}
        acc=${acc:+${acc}"'\"'\"'"}${head}
        if [ x"${tail}" = x"${head}" ]; then
            # didn't advance
            break;
        fi
    done
    echo "${acc}"
}

SRC_PREFIX=${SRC_PREFIX:-}
NOFAKE_SH=${NOFAKE_SH:-nofake.sh}
NOFAKE_SH_FLAGS=${NOFAKE_SH_FLAGS:-}
ECHO=${ECHO:-echo}
ECHO_ERROR=${ECHO_ERROR:-echo}
ECHO_INFO=${ECHO_INFO:-echo}

nargs= # nofake args
eargs= # exec args

for arg do
    if [ x"${arg}" = x-- ]; then
        shift
        break
    fi
    nargs="${nargs:+${nargs} }'`normalize_arg "${arg}"`'"
    shift # 'for' is synchronized with 'shift'
done

if [ x$# = x0 ]; then
    die 1 "Error, wrong usage, exec arguments are absent." 1>&2
fi

for arg do
    eargs="${eargs:+${eargs} }'`normalize_arg "${arg}"`'"
done

eval "set -- ${nargs}"

opts=
chunks=
sources=
output=
appendargs=
tmps=

while [ $# -gt 0 ]; do
    case "${1}" in
        -L*|--error) opts="${opts:+${opts} }'`normalize_arg "${1}"`'" ;;
        -R*) chunks="${chunks:+${chunks} }'`normalize_arg "${1}"`'" ;;

        -o|--output) output=`normalize_arg "${2}"`; shift ;;
        --output=*) output=`normalize_arg "${1#*=}"` ;;
        -o*) output=`normalize_arg "${1#??}"` ;;

        --tmp--) tmps="${tmps:+${tmps} }'`normalize_arg "${2}"`'"; shift ;;

        --aa--) appendargs="${appendargs:+${appendargs} }'`normalize_arg "${2}"`'"; shift ;;
        --dd--) appendargs="${appendargs:+${appendargs} }'--'" ;;

        --ba--) # begin args
            shift
            for arg; do
                if [ x"${1}" = x--ea-- ]; then
                    # end args
                    break
                fi
                appendargs="${appendargs:+${appendargs} }'`normalize_arg "${1}"`'"
                shift # 'for' is synchronized with 'shift'
            done
            ;;

        -) sources="${sources:+${sources} }'-'" ;;
        -*)
            ${ECHO_ERROR} "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;

        *) sources="${sources:+${sources} }'${SRC_PREFIX}`normalize_arg "${1}"`'" ;;
    esac
    shift
done

if [ x"${output}" = x ]; then
    # stamp file is generated by nofake.sh
    output=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${output}'"
    tmpfiles="${tmpfiles:+${tmpfiles} }'${output}.stamp'"

    eval "set -- ${tmps}"
    for arg; do
        if [ x"${arg}" = x ]; then
            die 1 "Error, additional temporary file suffix cannot be empty." 1>&2
        fi
        if [ x"${arg}" = x.stamp ]; then
            die 1 "Error, additional temporary file suffix \".stamp\" is already used." 1>&2
        fi
        tmpfiles="${tmpfiles:+${tmpfiles} }'${output}${arg}'"
    done
fi

eval "set -- ${opts} ${chunks} ${sources}"
ECHO_INFO=: ${NOFAKE_SH} ${NOFAKE_SH_FLAGS} "$@" -o"${output}"
eval "set -- ${eargs} '${output}' ${appendargs}"
"$@"
