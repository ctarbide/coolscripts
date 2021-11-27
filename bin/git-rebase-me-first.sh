#!/bin/sh

set -eux

git status --porcelain | awk '/^DU / {print $2}' | xargs -r git rm -f
git restore -S .
git checkout .

# is working tree in pristine state?
is_ok_to_continue_1(){
    git diff --quiet
}

# are there only known files?
is_ok_to_continue_2(){
    git status --porcelain | perl -lane'exit(1) if m{^\?\? }}{'
}

if is_ok_to_continue_1 && is_ok_to_continue_2; then
    git rebase --continue
else
    git status
fi

echo "all done for ${0##*/}"
