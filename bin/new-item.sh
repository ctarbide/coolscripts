#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
configname="${thisdir}/coolscripts.cfg"
configure(){
    if [ x"${1#*.}" = x"${1}" ] || ! git config -f "${configname}" "$@"; then
        name="coolscripts.${1}"; shift
        git config -f "${configname}" "${name}" "$@"
    fi
}
spaces_to_underscore(){
    head=
    tail=${1}
    acc=
    while true; do
        head=${tail%% *}
        tail=${tail#* }
        acc=${acc:+${acc}_}${head}
        if [ x"${tail}" = x"${head}" ]; then
            # didn't advance
            break;
        fi
    done
    echo "${acc}"
}

if [ "$#" -lt 1 ]; then
    die 1 "usage: ${thispath##*/} id1 id2 ... idN"
fi

kbdir=`"${thisdir}/show-config.sh" kbdir`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
year=${stamp%%-*}

for i; do
    j=`spaces_to_underscore "${i}"`
    item_id="${item_id:+${item_id}·}${j}"
done

STAMP=${stamp}
ITEM_ID=${item_id}
DOC_ID=${stamp}_${item_id}
DOCRELDIR=${year}/${DOC_ID}
DOCABSDIR=${kbdir}/${DOCRELDIR}

mkdir -p "${DOCABSDIR}"

"${thisdir}/make-index.sh" "${DOCRELDIR}"

cd "${DOCABSDIR}"

cat <<EOF>README.txt

${DOC_ID}

**************** references

- 

****************

EOF

echo 'echo '"'${DOCABSDIR}'"' | first-line-to-clipboard.sh'
