#!/bin/sh
set -eu
#
# usage examples:
#
#    git-last-modified.sh README.txt
#
#    TZ=Pacific/Samoa FORMAT='format-local:%B %e, %Y at %T %Z' git-last-modified.sh README.txt
#
#    FORMAT=format:%F git-last-modified.sh README.txt | perl -lne'print(qq{<<LAST MODIFIED>>=\n${_}\n@})'
#
#    FORMAT=format:%s git-last-modified.sh README.txt
#
# will output the date of the last commit relevant to the file
#
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

git_prefix(){ git -c core.quotepath=off rev-parse --show-prefix; }
git_lstree(){ git -c core.quotepath=off ls-tree --full-tree -r -t -l HEAD; }

get_blob_hash(){
    path_expr='^[0-7]+ \s+ blob \s+ [0-9a-f]+ \s+ \d+ \s+ \Q'"${prefix}"'\E '"${filename}"' $'
    git_lstree | perl -lane'next unless m{'"${path_expr}"'}x; print $F[2]; last'
}

FORMAT=${FORMAT:-format:%B %e, %Y at %T UTC}

prefix=`git_prefix`
filename=${1}

blob=`get_blob_hash "${1}"`

perl -le'exit($ARGV[0] !~ m{^[0-9a-f]+$}i)' -- "${blob}" || die 1 "Error, file \"${filename}\" not found in git history." 1>&2

git log -1 --format=%cd --date="${FORMAT}" --find-object="${blob}" HEAD
