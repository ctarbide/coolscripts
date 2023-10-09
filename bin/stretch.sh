#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){ u0Aa.sh | head -n"${1}" | perl -pe chomp; }
r0Aa(){ r0Aa.sh | head -n"${1}" | perl -pe chomp; }

temporary_file(){
    if command -v mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif command -v perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    elif command -v perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}
sha256(){ cat "$@" | sha256sum | perl -ane'print(pack(q{H*},$F[0]))'; }
bytes_to_bits=bytes-to-bits.sh
if command -v bytes-to-bits >/dev/null 2>&1; then
    bytes_to_bits=bytes-to-bits
fi
bytes_to_bits(){ "${bytes_to_bits}" "$@"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

lanes=16
space=16
time=16
while [ $# -gt 0 ]; do
    case "${1}" in
        -l|--lanes) lanes=${2}; shift ;;
        --lanes=*) lanes=${1#*=} ;;
        -l*) lanes=${1#??} ;;

        -s|--space) space=${2}; shift ;;
        --space=*) space=${1#*=} ;;
        -s*) space=${1#??} ;;

        -t|--time) time=${2}; shift ;;
        --time=*) time=${1#*=} ;;
        -t*) time=${1#??} ;;

        *)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
    esac
    shift
done

LC_ALL=C
export LC_ALL

masterkey=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${masterkey}'"
"${thisdir}/csprng.sh" | "${thisdir}/ddfb.sh" bs=32 count=1 skip=0 > "${masterkey}"
subkey1=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${subkey1}'"

subkey2=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${subkey2}'"

"${thisdir}/csprng.sh" < "${masterkey}" | "${thisdir}/ddfb.sh" bs=32 count=1 skip=0 > "${subkey1}"
"${thisdir}/csprng.sh" < "${masterkey}" | "${thisdir}/ddfb.sh" bs=32 count=1 skip=1 > "${subkey2}"
for i in `seq 1 "${lanes}"`; do
    rngkey=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${rngkey}'"
    eval 'rngkey'"${i}='${rngkey}'"
    shufflekey=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${shufflekey}'"
    eval 'shufflekey'"${i}='${shufflekey}'"
    "${thisdir}/csprng.sh" < "${subkey1}" | "${thisdir}/ddfb.sh" bs=32 count=1 skip="${i}" > "${rngkey}"
    "${thisdir}/csprng.sh" < "${subkey2}" | "${thisdir}/ddfb.sh" bs=32 count=1 skip="${i}" > "${shufflekey}"
done
spaces=
for i in `seq 1 "${lanes}"`; do
    eval 'rngkey=${rngkey'"${i}"'}'
    eval 'shufflekey=${shufflekey'"${i}"'}'

    spacearea=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${spacearea}'"

    spaceareatmp=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${spaceareatmp}'"

    spaces=${spaces:+${spaces} }"'${spacearea}'"

    eval 'spacearea'"${i}='${spacearea}'"
    eval 'spaceareatmp'"${i}='${spaceareatmp}'"

    "${thisdir}/csprng.sh" < "${rngkey}" | "${thisdir}/ddfb.sh" bs=128 count="${space}" | bytes_to_bits | "${thisdir}/random-prefix.sh" -k "${shufflekey}" >> "${spacearea}"
done
expected=$((3 + lanes * 4))
eval "set -- ${tmpfiles}"
if [ x"${#}" != x"${expected}" ]; then
    die 1 "Error, unexpected number of temporary files, try again."
fi
for i in `seq 1 "${lanes}"`; do
    eval 'spacearea=${spacearea'"${i}"'}'
    eval 'spaceareatmp=${spaceareatmp'"${i}"'}'
    eval 'shufflekey=${shufflekey'"${i}"'}'
    for j in `seq 1 "${time}"`; do
	sha256 < "${spacearea}" > "${shufflekey}"
        LC_ALL=C sort < "${spacearea}" | perl -lpe's,^.*?\t.*?\t,,' | "${thisdir}/random-prefix.sh" -k "${shufflekey}" > "${spaceareatmp}"
        cat < "${spaceareatmp}" > "${spacearea}"
    done
done
eval "set -- ${spaces}"
sha256 "$@"
