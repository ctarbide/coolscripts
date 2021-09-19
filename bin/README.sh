#!/bin/sh
set -eu #x
stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
pwd=`pwd`
thisdir=${pwd##*/}
if perl -le'exit($ARGV[0] !~ m{^ 2\d{3} - \d\d - \d\d _ \d\d h \d\d m \d\d _ }ix)' -- "${thisdir}"; then
    title=${thisdir}
else
    title=${stamp}_${thisdir}
fi
cat<<EOF

${title}

**************** references

- 

****************

EOF
