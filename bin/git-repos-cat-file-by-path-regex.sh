#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 1 ] || die 1 "usage: ${0##*/} repos.git regex"

GIT_DIR=$1
export GIT_DIR

path_expr=$2

blob=`git-repos-ls-files.sh "${GIT_DIR}" | perl -lane'next unless m{'"${path_expr}"'}; print($F[2])' | head -n1`

perl -le'exit($ARGV[0] !~ m{^[0-9a-f]+$}i)' -- "${blob}" || die 1 "error: file not found"

exec git cat-file blob "${blob}"
