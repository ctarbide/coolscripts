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
#@<<prog cwd>>
<<prog thisdir>>
@

<<prog cwd>>=
<<prog preamble>>
setnw KBLAYOUT "${KBLAYOUT}"
setnw CWD "`pwd`"
exec nofake-exec.sh --error -Rconf "${thispath}" "${0}.nw" -- \
    "${DOSBOX}" -conf
@

<<prog thisdir>>=
<<prog preamble>>
setnw KBLAYOUT "${KBLAYOUT}"
setnw CWD "${thisdir}"
exec nofake-exec.sh --error -Rconf "${thispath}" "${0}.nw" -- \
    "${DOSBOX}" -conf
@

<<prog preamble>>=
thispath=${1}; shift
thisprog=${thispath##*/}
thisdir=${thispath%/*}
setnw(){ printf -- '@<<%s>>=\n%s\n@\n' "${1}" "${2}" >>"${0}.nw"; }
@
