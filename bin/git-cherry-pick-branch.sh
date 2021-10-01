#!/bin/sh
set -eux
branch=${1:-dev}
git read-tree "${branch}"
git-rm-files-not-present-in-worktree.sh | sh
git clean -dxf
echo "all done for ${0##*/}"
