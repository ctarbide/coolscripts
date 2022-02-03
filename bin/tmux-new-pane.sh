#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

opts=
dir=.

for arg do
    case "${arg}" in
    -*)
        opts="${opts:+${opts} }'${arg}'"
        ;;
    *)
        test x"${dir}" = x. || die 1 "error: dir already specified as \"${dir}\""
        dir=${arg}
        ;;
    esac
done

test x"${dir}" = x. -o -d "${dir}" || die 1 "error: \"${dir}\" is not a directory"

realdir=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${dir}"`

eval "set -- ${opts}"
exec tmux split-window -c "${realdir}" "$@"
