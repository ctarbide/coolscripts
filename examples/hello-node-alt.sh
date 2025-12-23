#!/bin/sh
# https://github.com/ctarbide/coolscripts/blob/master/examples/dosbox-hello.sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
set -- "${thispath}" --ba-- "${thispath}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh -eu}; export SH
[ x"${ZSH_VERSION:-}" = x ] || setopt sh_word_split
NODE=${NODE:-node}; export NODE
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

****************

<<prog>>=
<<prog preamble>>
#@<<prog cwd>>
<<prog thisdir>>
<<setnw common>>
set -- --ba-- "$@" --ea-- "${thispath}" "${0}.nw"
exec nofake-exec.sh --error -Rdoit "$@" -- ${SH}
@

****************

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
<<function die>>
<<function setnw>>
thispath=${1}; shift
thisprog=${thispath##*/}
thisdir=${thispath%/*}
@

<<setnw common>>=
setnw AUXNW "${0}.nw"
setnw THISPATH "${thispath}"
setnw THISPROG "${thisprog}"
setnw THISDIR "${thisdir}"
setnw MAIN_PID "$$"
stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
setnw STAMP "${stamp}"
thisdirbasename=${thisdir##*/}
setnw THISDIRBASENAME "${thisdirbasename}"
@

****************

<<function die>>=
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
@

<<function setnw>>=
setnw(){ printf -- '@<<%s>>=\n%s\n@\n' "${1}" "${2}" >>"${0}.nw"; }
@

****************

<<doit>>=
set -- --ba-- "$@" --ea-- '<<THISPATH>>' '<<AUXNW>>'
set -- -o'<<THISDIR>>/.<<THISPROG>>.js' "$@"
exec nofake-exec.sh --error -Rjs "$@" -- ${NODE}
@

****************

<<js>>=
const bip39 = require('bip39')
const mnemonic = bip39.entropyToMnemonic("07d48e843e67c57148f91b2ae5eb92a4");
console.log(mnemonic);
@

****************
