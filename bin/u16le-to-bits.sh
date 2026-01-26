#!/bin/sh
# generated from bytes-to-bits.nw
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ $# -eq 0 ]; then
    set -- -
fi
exec perl -le'
    for $file (@ARGV) {
        if ($file eq q{-}) {
            $fh = \*STDIN;
        } else {
            open($fh, q{<}, $file);
        }
        while(read($fh, $d, 16384)){
            $offset = 0;
            $dlen = length($d);
            while($offset + 4 < $dlen){
                $bits = unpack(q{B*}, substr($d, $offset, 4));
                print(join(qq{\n},
                    substr($bits, 8, 1),
                    substr($bits, 9, 1),
                    substr($bits, 10, 1),
                    substr($bits, 11, 1),
                    substr($bits, 12, 1),
                    substr($bits, 13, 1),
                    substr($bits, 14, 1),
                    substr($bits, 15, 1),
                    substr($bits, 0, 1),
                    substr($bits, 1, 1),
                    substr($bits, 2, 1),
                    substr($bits, 3, 1),
                    substr($bits, 4, 1),
                    substr($bits, 5, 1),
                    substr($bits, 6, 1),
                    substr($bits, 7, 1),
                    substr($bits, 24, 1),
                    substr($bits, 25, 1),
                    substr($bits, 26, 1),
                    substr($bits, 27, 1),
                    substr($bits, 28, 1),
                    substr($bits, 29, 1),
                    substr($bits, 30, 1),
                    substr($bits, 31, 1),
                    substr($bits, 16, 1),
                    substr($bits, 17, 1),
                    substr($bits, 18, 1),
                    substr($bits, 19, 1),
                    substr($bits, 20, 1),
                    substr($bits, 21, 1),
                    substr($bits, 22, 1),
                    substr($bits, 23, 1),
                ));
                $offset += 4;
            }
            while($dlen - $offset >= 2){
                $bits = unpack(q{B*}, substr($d, $offset, 2));
                print(join(qq{\n},
                    substr($bits, 8, 1),
                    substr($bits, 9, 1),
                    substr($bits, 10, 1),
                    substr($bits, 11, 1),
                    substr($bits, 12, 1),
                    substr($bits, 13, 1),
                    substr($bits, 14, 1),
                    substr($bits, 15, 1),
                    substr($bits, 0, 1),
                    substr($bits, 1, 1),
                    substr($bits, 2, 1),
                    substr($bits, 3, 1),
                    substr($bits, 4, 1),
                    substr($bits, 5, 1),
                    substr($bits, 6, 1),
                    substr($bits, 7, 1),
                ));
                $offset += 2;
            }
        }
        close($fh) unless $file eq q{-};
    }' "$@"
