#!/bin/sh
# input: output from mdate-and-size.sh
# usage example: gzip -dc mdate-and-size.gz | ./filter-after.sh 2025-11-07
# tip: pipe this script output to 'sort -k1,1 -k3,3'
set -eu
exec perl -slane'next unless $F[0] ge $min; print' -- -min="${1}"
