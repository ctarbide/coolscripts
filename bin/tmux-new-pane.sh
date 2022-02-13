#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

opts= args= argsonly=
capture_for= capture=

for arg do
    if [ x"${capture}" = xtrue ]; then
        opts="${opts:+${opts} }'${arg}'"
        capture_for= capture=
        continue
    fi
    case "${arg}" in
    -l) opts="${opts:+${opts} }'${arg}'"
        capture_for=${arg} capture=true
        ;;
    --) argsonly=true ;;
    -*) if [ x${argsonly} = xtrue ];
            then args="${args:+${args} }'${arg}'"
            else opts="${opts:+${opts} }'${arg}'"
        fi
        ;;
    *) args="${args:+${args} }'${arg}'"	;;
    esac
done

if [ x"${capture}" = xtrue ]; then
    die 1 "error: argument value is missing for \"${capture_for}\" option"
fi

eval "set -- ${args}"

dir=${1:-.}
argv=

if [ $# -gt 0 ]; then
    shift
    for arg do
        argv="${argv:+${argv} }'${arg}'"
    done
fi

test x"${dir}" = x. -o -d "${dir}" || die 1 "error: \"${dir}\" is not a directory"

realdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${dir}"`

if [ x"${opts}" = x ]; then
    # some nice default options
    opts="-b -l '25%'"
fi

eval "set -- -c '${realdir}' ${opts} -- ${argv}"
exec tmux split-window "$@"
