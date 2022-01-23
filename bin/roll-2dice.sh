#!/bin/sh

# usage example:
# ./roll-2dice.sh 0a | head -n12 | perl -pe chomp

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

map=${MAP:-}
mapid=${1:-0}

count_groups(){
    perl -le'print(scalar(split(q{,},$ARGV[0],-1)))' -- "${1}"
}

if [ x"${map}" != x ]; then
    if [ x`count_groups "${map}"` != x36 ]; then
        die 1 "error: MAP environment variable must have 36 groups separated by comma"
    fi
else
    if [ x"${mapid}" = x0 ]; then
        map=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35
    elif [ x"${mapid}" = x1 ]; then
        map=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
    elif [ x"${mapid}" = x00 ]; then
        map=00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35
    elif [ x"${mapid}" = x01 ]; then
        map=01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
    elif [ x"${mapid}" = x0a ]; then
        map=0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
    elif [ x"${mapid}" = xa0 ]; then
        map=a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9
    else
        die 1 "error: unknown map id: \"${mapid}\""
    fi
fi

# 0..215 equals 6^3 possibilities, but discard the last roll, to converge faster

"${thisdir}/random-bytes.sh" | MAP="${map}" perl -lne'
    BEGIN { @map = split(q{,}, $ENV{MAP}) }
    next if $_ > 215;
    print($map[$_ % 36])
'
