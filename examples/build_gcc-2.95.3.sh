#!/bin/sh
# https://github.com/ctarbide/coolscripts/blob/master/examples/dosbox-hello.sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
set -- "${thispath}" --ba-- "${thispath}" "$@" --ea--
set -- "$@" --tmp-- .nw
SH=${SH:-sh -eu}; export SH
[ x"${ZSH_VERSION:-}" = x ] || setopt sh_word_split
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

**************** references

- https://www.linuxfromscratch.org/museum/lfs-museum/3.0-pre1/LFS-BOOK-3.0-pre1-HTML/ch05-gcc.html

**************** configuration

<<binutils prefix>>=
${HOME}/local--binutils-2.12.1
@

<<prefix>>=
${HOME}/local--gcc-2.95.3
@

<<build dir>>=
<<THISDIR>>/build
@

<<host>>=
i686-unknown-linux-gnu
@

<<target>>=
i686-unknown-linux-gnu
@

****************

<<prog>>=
<<prog preamble>>
#@<<prog cwd>>
<<prog thisdir>>
<<setnw common>>
set -- "${thispath}" "${0}.nw"
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
#!/bin/sh
set -eu
<<function die>>
<<set PATH_PREFIX>>
mkdir -pv "<<build dir>>"
(
   cd "<<build dir>>"
   if [ ! -f config.cache ]; then
      set --
      set -- "$@" --prefix="<<prefix>>"
      set -- "$@" --with-gxx-include-dir="<<prefix>>/include/g++"
      set -- "$@" --enable-languages=c,c++
      set -- "$@" --disable-nls
      set -- "$@" --host="<<host>>"
      set -- "$@" --target="<<target>>"
      run-pristine-environment.sh "<<THISDIR>>/configure" "$@"
   fi
   run-pristine-environment.sh make -e LDFLAGS=-static bootstrap
)
@

PATH_PREFIX is used by run-pristine-environment.sh

<<set PATH_PREFIX>>=
PATH_PREFIX="<<binutils prefix>>/bin"
export PATH_PREFIX
@

****************
