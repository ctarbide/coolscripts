#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
strip_r_slash(){ echo "$1" | perl -pe's,/*$,,'; }
hname=`hostname`; hname=${hname%%.*}
if [ x"${1:-}" != x ]; then
    if [ ! -d "${HOME}/Downloads/${1:-}" ]; then
        die 1 "error: \"${HOME}/Downloads/${1:-}\" does not exist"
    fi
    subdir=`strip_r_slash "${1}"`
    srcdir=${HOME}/Downloads/${subdir}
    dname=Downloads-from-${hname}--${USER}/${subdir}
else
    srcdir=${HOME}/Downloads
    dname=Downloads-from-${hname}--${USER}
fi
for dir in `perl -lane'next unless $F[1] =~ m{^/media/}; print($F[1])' /proc/mounts`; do
    if [ -d "${dir}/${dname}" ]; then
        echo ""
        echo "**************** syncing '${dir}/${dname}/'"
        rsync-dry-run.sh -av --delete-after "${srcdir}/" "${dir}/${dname}/" || true
    fi
done
