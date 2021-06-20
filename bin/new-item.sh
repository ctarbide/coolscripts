#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

if [ "$#" -lt 1 ]; then
    die 1 "usage: ${0} identification-string"
fi

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

test -x show-config.sh || make 1>&2
kbdir=`./show-config.sh coolscripts.kbdir`
test -d "${kbdir}" || die 1 "error: directory not found: ${kbdir}"

stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
year=${stamp%%-*}

item_id=$1
shift
for i in "$@"; do
    item_id="${item_id}·${i}"
done

STAMP=${stamp}
ITEM_ID=${item_id}
DOC_ID=${stamp}_${item_id}
DOCRELDIR=${year}/${DOC_ID}
DOCABSDIR=${kbdir}/${DOCRELDIR}

mkdir -p "${DOCABSDIR}"

./make-index.sh "${DOCRELDIR}"

cd "${DOCABSDIR}"

cat <<EOF>README.txt
# -*- mode: org; coding: utf-8-unix -*-

#+TITLE: ${DOC_ID}
#+STARTUP: indent


* References


- 


* Notes


EOF

echo 'echo '"${DOCABSDIR}"' | first-line-to-clipboard.sh'
