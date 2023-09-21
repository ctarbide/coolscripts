#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ -t 1 ]; then
    die 1 "Error, this is not supposed to output to a terminal."
fi

# due to envelope size of 2^16, there is a key size limitation
#
#    no items of 65528 key length: seq 12800 | dd bs=1 count=65528 | ./ctrbin.sh | hexdump -Cv | head -n1
#   1e1 items of 65527 key length: seq 12800 | dd bs=1 count=65527 | ./ctrbin.sh | hexdump -Cv | tail
#   1e2 items of 65526 key length: seq 12800 | dd bs=1 count=65526 | ./ctrbin.sh | hexdump -Cv | tail
#   1e3 items of 65525 key length: seq 12800 | dd bs=1 count=65525 | ./ctrbin.sh | hexdump -Cv | tail
#   ... and so on and so forth
#
# please also keep in mind that 65k-byte keys are insanely huge keys
#

exec perl -0777 -e'
    $_ = <>;
    $k = length($_).qq{:${_},};
    $max_e = 0xffff;
    sub envelope {
        $l = length($_[0]);
        die qq{"Envelope too large, greater than ${max_e}: ${l}."} if $l > $max_e;
        return pack(q{na*}, $l, $_[0]);
    }
    while (++$n) {
        print(envelope(qq{${k}${n}}));
    }'
