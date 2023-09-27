#!/bin/sh
# generated from lsb-to-bits.nw
# run 'nofake lsb-to-bits.nw' for shell recipe
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
if [ $# -eq 0 ]; then
    die 1 "Error, no data input. Use \"-\" for standard input."
    exit
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
            while($offset + 32 < $dlen){
                $bits = unpack(q{B*}, substr($d, $offset, 32));
                print(join(qq{\n},
                    substr($bits, 8*1-1, 1),
                    substr($bits, 8*2-1, 1),
                    substr($bits, 8*3-1, 1),
                    substr($bits, 8*4-1, 1),
                    substr($bits, 8*5-1, 1),
                    substr($bits, 8*6-1, 1),
                    substr($bits, 8*7-1, 1),
                    substr($bits, 8*8-1, 1),
                    substr($bits, 8*9-1, 1),
                    substr($bits, 8*10-1, 1),
                    substr($bits, 8*11-1, 1),
                    substr($bits, 8*12-1, 1),
                    substr($bits, 8*13-1, 1),
                    substr($bits, 8*14-1, 1),
                    substr($bits, 8*15-1, 1),
                    substr($bits, 8*16-1, 1),
                    substr($bits, 8*17-1, 1),
                    substr($bits, 8*18-1, 1),
                    substr($bits, 8*19-1, 1),
                    substr($bits, 8*20-1, 1),
                    substr($bits, 8*21-1, 1),
                    substr($bits, 8*22-1, 1),
                    substr($bits, 8*23-1, 1),
                    substr($bits, 8*24-1, 1),
                    substr($bits, 8*25-1, 1),
                    substr($bits, 8*26-1, 1),
                    substr($bits, 8*27-1, 1),
                    substr($bits, 8*28-1, 1),
                    substr($bits, 8*29-1, 1),
                    substr($bits, 8*30-1, 1),
                    substr($bits, 8*31-1, 1),
                    substr($bits, 8*32-1, 1),
                ));
                $offset += 32;
            }
            while($offset + 8 < $dlen){
                $bits = unpack(q{B*}, substr($d, $offset, 8));
                print(join(qq{\n},
                    substr($bits, 8*1-1, 1),
                    substr($bits, 8*2-1, 1),
                    substr($bits, 8*3-1, 1),
                    substr($bits, 8*4-1, 1),
                    substr($bits, 8*5-1, 1),
                    substr($bits, 8*6-1, 1),
                    substr($bits, 8*7-1, 1),
                    substr($bits, 8*8-1, 1),
                ));
                $offset += 8;
            }
            while($offset < $dlen){
                print(substr(unpack(q{B*}, substr($d, $offset++, 1)), 7, 1));
            }
        }
        close($fh) unless $file eq q{-};
    }' "$@"
