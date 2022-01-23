#!/bin/sh

set -eu

echo 'checking gzip (*gz, *.Z)'
find ./ \( -iname '*gz' -o -name '*.Z' \) \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty gzip -t

echo 'checking bzip2 (*bz2, *bz)'
find ./ \( -iname '*bz2' -o -iname '*bz' \) \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty bzip2 -t

echo 'checking xz (*xz)'
find ./ -iname '*xz' \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty xz -t

echo 'checking lz (*lz)'
find ./ -iname '*lz' \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty lzip -t

echo 'checking zip, jar (*.zip, *.jar, *.apk)'
find ./ \( -iname '*.zip' -o -iname '*.jar' -o -iname '*.apk' \) \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty unzip -tq

echo 'checking sha1sum (*sha1sum)'
find ./ -iname '*sha1sum' \( -type f -or -xtype f \) -print0 | xargs -0 --no-run-if-empty -Iiii sh -c 'cd "$(dirname "iii")"; sha1sum -c "$(basename "iii")"'

echo 'checking md5sum (*md5sum)'
find ./ -iname '*md5sum' \( -type f -or -xtype f \) -print0 | xargs -0 --no-run-if-empty  -Iiii sh -c 'cd "$(dirname "iii")"; md5sum -c "$(basename "iii")"'

echo 'checking 7zip (*.7z)'
find ./ -iname '*.7z' \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty 7za t | grep -i '^\(error:\|processing archive:\|sub items errors:\)'

echo 'checking rpm (*.rpm)'
find ./ -iname '*.rpm' \( -type f -or -xtype f \) -print0 | xargs -0n1 --no-run-if-empty 7za t | grep -i '^\(error:\|processing archive:\|sub items errors:\)'

echo 'checking git connectivity and validity of objects (git fsck)'
find ./ \( -iwholename '*/refs/heads/master' -a ! -iwholename '*/logs/refs/heads/master' \) \( -type f -or -xtype f \) | while read i; do echo "checking $i"; GIT_DIR="${i%/refs/heads/master}" git fsck; done

echo 'checking git pack files integrity'
find ./ -iwholename '*/objects/pack/*.pack' \( -type f -or -xtype f \) | while read i; do git verify-pack "${i%.pack}"; done

echo all done
