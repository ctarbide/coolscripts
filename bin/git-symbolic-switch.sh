#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

branch=${1:-}

if [ x"${branch}" = x ]; then
    die 1 "usage: ${0##*/} branch"
fi

git symbolic-ref HEAD "refs/heads/${branch}"

if git rev-parse --verify --quiet "${branch}" >/dev/null; then
    # branch exists, read it's tree
    git read-tree "${branch}"
else
    echo "clearing index, since ${branch} does not exist yet"
    git read-tree --empty
fi

git status -uno
