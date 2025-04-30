#!/bin/sh
set -eu
k=/tmp/test$$key
d=/tmp/test$$data
echo -n 1 >"${k}"
perl -le'@a = reverse(map {chr} 33..126); print for @a' >"${d}"
echo
echo the two lines below must match
random-prefix.sh -k "${k}" <"${d}" | perl -lpe's,^[\w]{15},,' | LC_ALL=C sort | perl -lpe's,^.*?\t.*?\t,,' | sha256sum
random-prefix-noseq.sh -k "${k}" <"${d}" | perl -lpe's,^[\w]{15},,' | LC_ALL=C sort -s -k 1,1 | perl -lpe's,^.*?\t,,' | sha256sum
echo
echo 'failure example, line below may not match, depends on sort stability'
random-prefix-noseq.sh -k "${k}" <"${d}" | perl -lpe's,^[\w]{15},,' | LC_ALL=C sort -k 1,1 | perl -lpe's,^.*?\t,,' | sha256sum
echo
echo 'failure example, line below fails'
random-prefix-noseq.sh -k "${k}" <"${d}" | perl -lpe's,^[\w]{15},,' | LC_ALL=C sort -s | perl -lpe's,^.*?\t,,' | sha256sum
rm -f "${k}" "${d}"
