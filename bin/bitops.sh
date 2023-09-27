#!/bin/sh

# generated from bitops.nw
# run 'nofake bitops.nw' for shell recipe

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

if [ $# -eq 0 ]; then
    die 1 "Error, no data input. Use \"-\" for standard input."
    exit
fi

tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){ "${thisdir}/u0Aa.sh" | head -n"${1}" | perl -pe chomp; }
r0Aa(){ "${thisdir}/r0Aa.sh" | head -n"${1}" | perl -pe chomp; }

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

args=
stdincnt=0
clear=0
xor=

while [ $# -gt 0 ]; do
    case "${1}" in
        -c|--clear) clear=${2}; shift ;;
        --clear=*) clear=${1#*=} ;;
        -c*) clear=${1#??} ;;

        -x|--xor) xor=${2}; shift ;;
        --xor=*) xor=${1#*=} ;;
        -x*) xor=${1#??} ;;

        -)
            stdincnt=$((stdincnt+1))
            args="${args:+${args} }-"
            ;;
        --) ;; # no-op
        -*)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
        *) args="${args:+${args} }'${1}'" ;;
    esac
    shift
done

if [ x"${xor}" = x ]; then
    die 1 "Error, \"xor\" input is required."
fi

if [ x"${args}" = x ]; then
    die 1 "Error, no input data."
fi

slurp_to=

if [ "${stdincnt}" -eq 1 ]; then
    if [ x"${xor}" = x- ]; then
        die 1 "Error, ambiguous usage of standard input."
    fi
elif [ "${stdincnt}" -gt 1 ]; then
    slurp_to=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${slurp_to}'"
    eval "set -- ${args}"
    args=
    while [ $# -gt 0 ]; do
        case "${1}" in
            -) args="${args:+${args} }'${slurp_to}'" ;;
            *) args="${args:+${args} }'${1}'" ;;
        esac
        shift
    done
fi

if [ x"${slurp_to}" != x ]; then
    if [ x"${xor}" = x- ]; then
        die 1 "Error, ambiguous usage of standard input."
    fi
    cat > "${slurp_to}"
fi

if [ x"${xor}" = x- ]; then
    xor=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${xor}'"
    cat > "${xor}"
fi

eval "set -- ${args}"

cat "$@" | "${thisdir}/binpaste.pl" - "${xor}" | CLEAR="${clear}" perl -e'
    $c = $ENV{CLEAR} ^ 0xff;
    while(read(STDIN, $d, 2)){
        ($v, $x) = unpack(q{CC}, $d);
        print(chr(($v & $c) ^ $x));
    }'
