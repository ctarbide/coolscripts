#!/bin/sh
exec perl -le'
@map=map{chr}48..57,65..90,97..122,37,43..46,61,64,95;
sub r{int(rand(scalar(@map)))}
for (;;) { print($map[r]) }'
