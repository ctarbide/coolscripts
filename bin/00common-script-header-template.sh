#!/bin/sh

set -eux

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# thispath uses symlink
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`

# thispath follows real path
# thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`

thisprog=${thispath##*/}
thisdir=${thispath%/*}
thisdirbasename=${thisdir##*/}
thisparentdir=${thisdir%/*}

# very useful for keyprefix--do-stuff.sh cases
# thisprefix=${thisprog%--*.sh}

cd "${thisdir}"

if perl -le'exit(time()%2)'; then
    die 1 "error: this is just and example"
fi

####

echo "all done for \"${0##*/}\""
