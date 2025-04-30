#!/bin/sh
exec perl -le'
@map = map {chr} 33..126;
sub r{int(rand(scalar(@map)))}
for (;;) { print $map[r] }'
