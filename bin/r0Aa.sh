#!/bin/sh
exec perl -le'
@map=map{chr}48..57,65..90,97..122;
sub r{int(rand(scalar(@map)))}
for (;;) { print($map[r]) }'
