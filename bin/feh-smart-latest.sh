#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

LC_ALL=C
export LC_ALL

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
glob_has_file(){
    perl -le'exit 0 for grep {-f} glob($ARGV[0]); exit 1' "${1}"
}

filelist=`temporary_file`
tmpfiles="${tmpfiles:+${tmpfiles} }'${filelist}'"

if [ "$#" -le 0 ]; then
    if glob_has_file "${HOME}/Downloads/Pictures/Screenshot_*.png"; then
        ls -1 ~/Downloads/Pictures/Screenshot_*.png >>"${filelist}"
    fi
else
    for i in "$@"; do
        if ! perl -le'exit($ARGV[0] !~ m{^ 2 \d{3} $}x)' -- "${i}"; then
            die 1 "error: invalid argument, must be a year"
        fi
    done
    years=$@
    for i in $years; do
        if glob_has_file "${HOME}/Downloads/Pictures/${i}/Screenshot_*.png"; then
            ls -1 ~/Downloads/Pictures/"${i}"/Screenshot_*.png >>"${filelist}"
        fi
    done
fi

nimg=`wc -l "${filelist}"`
if [ "${nimg}" -le 0 ]; then
    die 1 "error: no files to show"
fi

exec feh-smart.sh --filelist "${filelist}" "$@" --
