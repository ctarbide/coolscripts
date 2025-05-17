#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/hello-dosbox.sh.html
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
set -- "${thispath}" --ba-- "${thispath}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh -eu}; export SH
DOSBOX=${DOSBOX:-dosbox}; export DOSBOX
KBLAYOUT=${KBLAYOUT:-us}; export KBLAYOUT
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

<<autoexec>>=
mount c "<<CWD>>"
c:
echo "hello world!"
@

<<conf>>=
[dos]
keyboardlayout=<<KBLAYOUT>>
[autoexec]
<<autoexec>>
@

<<prog>>=
<<prog preamble>>
#@<<prog cwd>>
<<prog thisdir>>
setnw KBLAYOUT "${KBLAYOUT}"
exec nofake-exec.sh --error -Rconf "${thispath}" "${0}.nw" -- \
    "${DOSBOX}" -conf
@

'pwd' cleans the path from '..' elements

<<prog cwd>>=
thisdir=`cd "${thisdir}" && pwd`
setnw CWD "`pwd`"
@

<<prog thisdir>>=
cd "${thisdir}"
thisdir=`pwd`
setnw CWD "${thisdir}"
@

<<prog preamble>>=
thispath=${1}; shift
thisprog=${thispath##*/}
thisdir=${thispath%/*}
setnw(){ printf -- '@<<%s>>=\n%s\n@\n' "${1}" "${2}" >>"${0}.nw"; }
@
