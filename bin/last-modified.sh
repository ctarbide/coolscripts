#!/bin/sh
exec perl -le'do { $max = $_ if $_ > $max } for map {(stat $_)[9]} @ARGV; print $max' -- "$@"
