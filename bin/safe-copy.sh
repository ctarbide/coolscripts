#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# thispath uses symlink
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`

# thispath follows real path
# thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`

thisprog=${thispath##*/}
thisdir=${thispath%/*}
thisdirbasename=${thisdir##*/}
thisparentdir=${thisdir%/*}

[ "$#" -gt 0 ] || die 1 "usage: ${0##*/} file1 file2 ..."

exec "${thisdir}/safe-rename.sh" --copy-instead "$@"
