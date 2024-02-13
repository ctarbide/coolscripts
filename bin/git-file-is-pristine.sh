#!/bin/sh
# usage: git-file-is-pristine.sh git-file-is-pristine.sh && echo is pristine
set -eu
for file do
    # does it even exists?
    [ -e "${file}" ]

    # not versioned implies nonpristine
    other=`git ls-files -o -- "${file}"`
    [ x"${other}" = x ]

    # diff-index also tracks file modification time, this prevents diff-index
    # failing after a touch
    git update-index --refresh -q

    # versioned and without differences to working copy?
    git diff-index --quiet HEAD -- "${file}"
done
