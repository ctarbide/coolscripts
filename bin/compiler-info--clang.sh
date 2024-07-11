#!/bin/sh
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .c --tmp-- .out
SH=${SH:-sh -eu}; export SH
CC=${CC:-clang}; export CC
CFLAGS=${CFLAGS:-}; export CFLAGS
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

Provides these normalized information for portability purposes

   - uname -srm

   - compiler name

   - compiler path

   - compiler version major

   - compiler version minor

   - compiler version patchlevel

   - compiler pre-defines

   - found headers

   - not found headers

This script is specific for clang, the "C language family frontend for LLVM",
other compilers are also provided with different scripts.

References

   - https://clang.llvm.org/

N.B: The default include path can be derived from the found headers, e.g.:

    nofake -R'usage example 1' compiler-info--clang.sh

<<prog>>=
<<function die>>
<<function simple_chunk>>

uname_srm=`uname -srm`
if [ x"${uname_srm}" = x ]; then
   die 1 "Failed to identify the current system." >&2
fi

compiler_name=clang

compiler_path=`command -v "${CC}"`
if [ x"${compiler_path}" = x ]; then
   die 1 "compiler \"${CC}\" not found"
fi

compiler_version_major=`echo __clang_major__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_major}" = x"__clang_major__" ]; then
    die 1 "Failed to determine ${compiler_name} major version." >&2
fi

compiler_version_minor=`echo __clang_minor__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_minor}" = x"__clang_minor__" ]; then
    die 1 "Failed to determine ${compiler_name} minor version." >&2
fi

compiler_version_patchlevel=`echo __clang_patchlevel__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_patchlevel}" = x"__clang_patchlevel__" ]; then
    die 1 "Failed to determine ${compiler_name} patchlevel version." >&2
fi

simple_chunk 'uname -srm' "${uname_srm}"
simple_chunk 'compiler name' "${compiler_name}"
simple_chunk 'compiler path' "${compiler_path}"
simple_chunk 'compiler version major' "${compiler_version_major}"
simple_chunk 'compiler version minor' "${compiler_version_minor}"
simple_chunk 'compiler version patchlevel' "${compiler_version_patchlevel}"
simple_chunk CFLAGS "${CFLAGS}"

printf -- '@<<compiler predefines>>=\n'
echo | "${compiler_path}" ${CFLAGS} -dM -E -
printf -- '@\n'

<<analyse headers>>
@

<<function die>>=
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
@

<<function simple_chunk>>=
simple_chunk(){
   printf -- '@<<%s>>=\n' "${1}"
   printf -- '%s\n' "${2}"
}
@

<<headers of interest>>=
set -- "$@" stddef.h
set -- "$@" stdarg.h
set -- "$@" stdio.h
set -- "$@" stdlib.h
set -- "$@" inttypes.h
set -- "$@" unistd.h
set -- "$@" sys/stat.h
set -- "$@" time.h
set -- "$@" math.h
set -- "$@" stdint.h
set -- "$@" string.h
set -- "$@" fcntl.h
set -- "$@" assert.h
set -- "$@" locale.h
set -- "$@" ctype.h
set -- "$@" limits.h
set -- "$@" signal.h
set -- "$@" setjmp.h
set -- "$@" errno.h
set -- "$@" pthread.h
set -- "$@" sys/mman.h
set -- "$@" utime.h
set -- "$@" dlfcn.h
set -- "$@" sys/time.h
set -- "$@" sys/resource.h
set -- "$@" pwd.h
set -- "$@" alloca.h
set -- "$@" malloc.h
set -- "$@" sys/types.h
set -- "$@" sys/wait.h
set -- "$@" sys/ioctl.h
set -- "$@" stdio_ext.h
@

<<analyse headers>>=
set --
<<function test_inclusion>>
<<headers of interest>>
hdr=stddef.h
(
    for hdr; do
       test_inclusion "${hdr}"
    done
) | perl -wlne'
    if (m{^found \047(.+?)\047 \047(.+?)\047$}) {
        printf(qq{@<<header %s>>=\n}, $1);
        print $2;
        printf(qq{@<<includes>>=\n}, $1);
        printf(qq{#include <%s>\n}, $1);
        printf(qq{@<<passthru includes>>=\n}, $1);
        printf(qq{#passthru "includes" #include <%s>\n}, $1);
        print(qq{@<<headers>>=});
        printf(qq{@<<header %s>>\n}, $1);
        (my $def = uc $1) =~ s,\.,_,g;
        $def =~ s,/,__,g;
        print(qq{@<<definitions>>=});
        printf(qq{#define HAVE_%s 1\n}, $def);
        print(qq{@<<passthru definitions>>=});
        printf(qq{#passthru "definitions" #define HAVE_%s 1\n}, $def);
        next;
    }
    if (m{^notfound \047(.+?)\047$}) {
        print(qq{@<<headers not found>>=});
        print $1;
        next;
    }
    # ignore
'
printf -- '@\n'
@

<<function test_inclusion>>=
test_inclusion(){
    printf -- '#include <%s>\n' "${1}" |
        "${compiler_path}" ${CFLAGS} -E -x c - 2>/dev/null |
        perl -wslne'
            next unless m{^\# \s \d+ \s " (.+?) "}xi;
            if (rindex($1, $suffix) > 0) {
                print(qq{found \047${suffix}\047 \047${1}\047});
                exit;
            }
        }{
            print(qq{notfound \047${suffix}\047});
        ' -- -suffix="${1}"
}
@

<<usage example 1>>=
compiler-info--clang.sh | nofake --error -Rheaders |
    perl -lne'die unless m{^(.*)/}; print($1) unless $found{$1}++'
@
