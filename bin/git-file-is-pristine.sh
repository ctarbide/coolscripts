#!/bin/sh
# usage: git-file-is-pristine.sh git-file-is-pristine.sh && echo is pristine
set -eu
for file do
    # does it even exists?
    [ -e "${file}" ]

    # not versioned implies nonpristine
    other=`git ls-files -o -- "${file}"`
    [ x"${other}" = x ]

    # 'git status' sync the index with working copy modification
    # times, this prevents 'diff-index' failing after a 'touch'
    git status --porcelain -- "${file}" >/dev/null

    # versioned and without differences to working copy?
    git diff-index --quiet HEAD -- "${file}"
done
