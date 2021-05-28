changequote(`', `')dnl
dnl
#!/bin/sh

# ./show-config.sh coolscripts.configname

set -eu #x

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
cd "${thispath%/*}"

configname=CONFIGNAME
test -f "${configname}" || make 1>&2

if [ $# -eq 0 ]; then
    exec git config -f "${configname}" --get-regexp '.*'
fi

exec git config -f "${configname}" "$@"
