#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

opts=
dir=.
len=
capture_for=
capture=

for arg do
    if [ x"${capture}" = xtrue ]; then
        opts="${opts:+${opts} }'${arg}'"
        capture_for=
        capture=
        continue
    fi
    case "${arg}" in
    -l)
        opts="${opts:+${opts} }'${arg}'"
        capture_for=${arg}
        capture=true
        ;;
    -*)
        opts="${opts:+${opts} }'${arg}'"
        ;;
    *)
        test x"${dir}" = x. || die 1 "error: dir already specified as \"${dir}\""
        dir=${arg}
        ;;
    esac
done

if [ x"${capture}" = xtrue ]; then
    die 1 "error: argument value is missing for \"${capture_for}\" option"
fi

test x"${dir}" = x. -o -d "${dir}" || die 1 "error: \"${dir}\" is not a directory"

realdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${dir}"`

if [ x"${opts}" = x ]; then
    # some nice default options
    opts="-b -l '25%'"
fi

eval "set -- ${opts}"
exec tmux split-window -c "${realdir}" "$@"
