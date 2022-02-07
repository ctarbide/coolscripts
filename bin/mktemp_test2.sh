#!/bin/sh

# similar to mktemp_test.sh, but independent of 'u0Aa.sh' and
# 'r0Aa.sh'

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

tmpfiles=

rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -fv -- "$@"
}

# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15

u0Aa(){
    perl -0777 -e'
        @map=map{chr}48..57,65..90,97..122;
        $c = $ARGV[0];
        while($c and read(STDIN,$d,64)){
            for $x (unpack(q{C*},$d)) {
                last unless $c;
                next if $x >= scalar(@map);
                $c--;
                print($map[$x]);
            }
        }' -- "${1}" </dev/urandom
}

r0Aa(){
    perl -e'
        @map=map{chr}48..57,65..90,97..122;
        sub c{$map[int(rand(scalar(@map)))]}
        for ($c=$ARGV[0];$c;$c--) { print(c) }' -- "${1}"
}

temporary_file(){
    if type mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif type perl >/dev/null 2>&1 && test -r /dev/urandom; then
        tmpfile="/tmp/tmp.`u0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    elif type perl >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`r0Aa 10`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}

echo "**** a: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"
echo "**** b: [${tmpfiles}]"

tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"
echo "**** c: [${tmpfiles}]"

date > "${tmpfile}"

cat "${tmpfile}"

eval "set -- ${tmpfiles}"
ls -lh "$@"

echo done
