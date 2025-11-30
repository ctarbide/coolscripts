#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){
perl -le'
@map = map {chr} 48..57, 65..90, 97..122;
while (read(STDIN,$d,64)) {
    for $x (unpack(q{C*},$d)) {
        next if $x >= @map;
        print $map[$x];
    }
}' </dev/urandom |
    head -n"${1}" | perl -pe chomp; }

r0Aa(){
perl -le'
@map = map {chr} 48..57, 65..90, 97..122;
sub r{int(rand(scalar(@map)))}
for (;;) { print $map[r] }' |
    head -n"${1}" | perl -pe chomp; }

create_safe_file(){
    ( umask 0177; : >"${1}" )
}

# mktemp isn't portable, can't use it
temporary_file(){
    if command -v perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`${1:-}"
        create_safe_file "${tmpfile}"
    elif command -v perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 12`${1:-}"
        create_safe_file "${tmpfile}"
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}
listing(){
    gzip -dc "${kbdir}/index.gz" | cut -b 26-
}

kbdir=`"${thisdir}/show-config.sh" kbdir`
test -d "${kbdir}" || die 1 "Error, directory not found: ${kbdir}."

perlprint=
if [ x"${PERLPRINT:-}" != x ]; then
    perlprint=${PERLPRINT}
else
    perlprint='print(qq{'"${kbdir}"'/*/*_$_})}{exit(!$.)'
fi

if [ "$#" -eq 1 ]; then
    listing | fgrep -i "$@" | perl -lne"${perlprint}"
elif [ "$#" -gt 1 ]; then
    tmpfile=`temporary_file`
    tmpfiles="${tmpfiles:+${tmpfiles} }'${tmpfile}'"

    first=$1; shift
    listing | fgrep -i "${first}" > "${tmpfile}" || true # 'true' prevents fgrep from exiting
    for i in "$@"; do
        cat "${tmpfile}" | fgrep -i "${i}" > "${tmpfile}0" || true # 'true' prevents fgrep from exiting
        mv "${tmpfile}0" "${tmpfile}"
    done
    cat "${tmpfile}" | perl -lne"${perlprint}"
    rm -f "${tmpfile}"
else
    listing | perl -lne"${perlprint}"
fi
