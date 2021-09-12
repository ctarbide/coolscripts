#!/bin/sh
set -eu
git status --porcelain | perl -lne'next unless m{^AD }; print(substr($_,3))' | perl -l0 -pe1 | xargs -r0 -n1 echo git rm
