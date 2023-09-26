#!/bin/sh

set -eu

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}

key=-
args=

while [ $# -gt 0 ]; do
    case "${1}" in
        -k|--key) key=${2}; shift ;;
        --key=*) key=${1#*=} ;;
        -k*) key=${1#??} ;;

        --) ;; # no-op
        *)
            echo "${0##*/}: Unrecognized option '${1}'." 1>&2
            exit 1
            ;;
    esac
    shift
done

"${thisdir}/csprng.sh" -k "${key}" | perl -e'
    $c0 = 0;
    $c1 = 0;
    sub seq {
        $c0 = ($c0 + 1) & 0xffffffff;
        $c1 = ($c1 + 1) & 0xffffffff unless $c0;
        sprintf(q{%08x%08x}, $c1, $c0);
    }
    while (read(STDIN, $d, 8)){
        ($a, $b) = unpack(q{N*}, $d);
        printf(qq{%08x%08x\t%s\n}, $a, $b, seq);
    }'
