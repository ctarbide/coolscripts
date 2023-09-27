#!/bin/sh
set -eu
exec perl -ne'
    chomp;
    $bits .= $_;
    if (length($bits) == 8) {
        print(pack(q{B8},$bits));
        $bits = q{};
    }' "$@"
