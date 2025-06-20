#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .c --tmp-- .out
SH=${SH:-sh -eu}; export SH
[ x"${ZSH_VERSION:-}" = x ] || setopt sh_word_split
CC=${CC:-gcc}; export CC
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
LIBS=${LIBS:-}; export LIBS
if [ x"${SOURCE_IN_STDIN:-}" = x1 ]; then
    exec nofake-exec.sh --error -R'prog stdin' "$@" --tmp-- _in.nw -- ${SH}
else
    exec nofake-exec.sh --error -R'prog snippet' "$@" -- ${SH}
fi
exit 1

Usage examples:

    c-expr.sh

    seq 100 | c-expr.sh a 'b c' ' ${d} '

    SHOW_SOURCE=1 c-expr.sh

    CC=clang ./c-expr.sh

    CC=tcc ./c-expr.sh

Useful environment variables:

    SOURCE_IN_STDIN=1

    SHOW_SOURCE=1

    DO_NOT_COMPILE=1

    DO_NOT_ASSEMBLE=1

    DO_NOT_LINK=1

    INCLUDE_HOME_LOCAL=1

    SAVE_C_SOURCE_TO=out.c

    SAVE_OUTPUT_TO=a.out

<<snippet>>=
int i = 0;
while (fgetc(stdin) != EOF) i++;
if (i) {
    printf("got %d bytes from standard input\n", i);
}
for (i=0; i < argc; i++) {
    fprintf(stdout, "[%d:%s]\n", i, argv[i]);
}
puts("hello world!");
@

<<c source - snippet>>=
<<c source - preamble>>
<<main - snippet>>
@

<<c source - stdin>>=
<<c source - preamble>>
<<main - stdin>>
@

<<main - snippet>>=
int
main(int argc, char **argv, char **envp)
{
    setlocale(LC_ALL, "C");
    do {
        <<snippet>>
    } while (0);
    return 0;
}
@

<<main - stdin>>=
int
main(int argc, char **argv, char **envp)
{
    <<stdin>>
    return 0;
}
@

<<c source - preamble>>=
<<c header>>
<<c standards>>
<<includes - before>>
<<includes>>
<<includes - after>>
<<definitions>>
<<types>>
<<globals>>
<<protos>>
<<impl>>
@

<<includes>>=
#include <stddef.h>
#include <stdint.h>
#include <math.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/socket.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/ioctl.h>
#include <sys/param.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <locale.h>
#include <ctype.h>
#include <limits.h>
#include <signal.h>
#include <setjmp.h>
#include <errno.h>
@

<<prog snippet>>=
<<prog preamble>>
if ! nofake-exec.sh --error -R'c source - snippet' -o"${0}.c" "$@"; then
    show-line-numbers.sh "${0}.c"
    exit 1
fi
[ -t 0 ] && exec 0>&-
<<run program>>
@

<<prog stdin>>=
<<prog preamble>>
<<function escape_chunk>>
printf -- '@<<stdin>>=\n' >"${0}_in.nw"
cat | escape_chunk >>"${0}_in.nw"
exec 0>&-
if ! nofake-exec.sh --error -R'c source - stdin' -o"${0}.c" "${0}_in.nw" "$@"; then
    show-line-numbers.sh "${0}.c"
    exit 1
fi
if [ x"${SAVE_C_SOURCE_TO:-}" != x ]; then
    rm -f "${SAVE_C_SOURCE_TO}"
    cp -av "${0}.c" "${SAVE_C_SOURCE_TO}" >&2
fi
<<run program>>
@

<<run program>>=
eval "set -- ${saveargs}"
postrun "$@"
@

<<function escape_chunk>>=
escape_chunk(){
    perl -lpe's,^\@($| ),\@\@${1},; s,([^\@])@<<,${1}\@@<<,g'
}
@

<<prog preamble>>=
<<function cmd_push_to_argv>>
thisprog=${1}; shift # the initial script
saveargs=; for arg do saveargs="${saveargs:+${saveargs} }'${arg}'"; done
set -- "${thisprog}"
if [ x"${ADDITIONAL_SOURCES:-}" != x ]; then
    set_add_srcs=`echo "${ADDITIONAL_SOURCES:-}" | cmd_push_to_argv`
    eval "${set_add_srcs}"
fi
if [ x"${SHOW_SOURCE:-}" = x1 ]; then
    set -- "$@" -- cat
    postrun(){ :; }
else
    set -- "$@" -- ${CC}
    <<set CFLAGS>>
    set -- "$@" ${LIBS}
    a_out=${0}.out
    if [ x"${DO_NOT_COMPILE:-}" = x1 ]; then
        set -- "$@" -E -P
        postrun(){ :; }
    elif [ x"${DO_NOT_ASSEMBLE:-}" = x1 ]; then
        set -- "$@" -S -o -
        postrun(){ :; }
    elif [ x"${DO_NOT_LINK:-}" = x1 ]; then
        set -- "$@" -c -o "${thisprog%.sh}.o"
        postrun(){ file "${thisprog%.sh}.o"; }
    else
        set -- "$@" -o "${a_out}" ${LDFLAGS}
        if [ x"${SAVE_OUTPUT_TO:-}" != x ]; then
            postrun(){ cp -av "${a_out}" "${SAVE_OUTPUT_TO}" >&2; }
        else
            postrun(){ "${a_out}" "$@"; }
        fi
    fi
fi
@

<<function cmd_push_to_argv>>=
cmd_push_to_argv(){
    normalize-args.sh | perl -lpe'$_=qq{set -- \042\$\@\042 ${_};}' |
        LC_ALL=C sort -u
}
@

<<set CFLAGS>>=
case "${CC}" in
gcc*)
    <<set CFLAGS - gcc>>
    ;;
clang*)
    <<set CFLAGS - clang>>
    ;;
tcc*)
    <<set CFLAGS - tcc>>
    ;;
*)
    echo "Warning, unknown compiler, trying generic CFLAGS=[-O2 -Wall]" >&2
    set -- "$@" -O2 -Wall
    ;;
esac

@

<<set CFLAGS - gcc>>=
<<set CFLAGS - gcc - pedantic>>
@

<<set CFLAGS - clang>>=
<<set CFLAGS - clang - pedantic>>
@

<<set CFLAGS - tcc>>=
<<set CFLAGS - tcc - pedantic>>
@

'-Wno-long-long' allow use of 64-bit constants (ull suffix) with ansi

<<set CFLAGS - gcc - pedantic>>=
set -- "$@" -O2 -ansi -pedantic
set -- "$@" -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes
set -- "$@" -Wshadow -Wconversion -Wdeclaration-after-statement
set -- "$@" -Wno-unused-parameter -Wno-long-long
set -- "$@" -Wredundant-decls -Wpointer-arith
set -- "$@" -Werror
gccver=`echo __GNUC__ | gcc -E -P -x c -`
if [ "${gccver}" -ge 6 ]; then
    set -- "$@" -fmax-errors=3
fi
<<also consider "${HOME}/local"?>>
@

'-Wno-long-long' allow use of 64-bit constants (ull suffix) with ansi

<<set CFLAGS - clang - pedantic>>=
set -- "$@" -O2 -ansi -pedantic
set -- "$@" -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes
set -- "$@" -Wshadow -Wconversion -Wdeclaration-after-statement
set -- "$@" -Wno-unused-parameter -Wno-long-long
set -- "$@" -Wredundant-decls -Wpointer-arith
set -- "$@" -Werror
<<also consider "${HOME}/local"?>>
@

<<set CFLAGS - tcc - pedantic>>=
set -- "$@" -O2 -Wall -Werror
<<also consider "${HOME}/local"?>>
@

<<c header>>=

<<includes - before>>=

<<includes - after>>=

<<definitions>>=

<<types>>=

<<globals>>=

<<protos>>=

<<impl>>=

<<c standards>>=
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#ifndef _ISOC99_SOURCE
#define _ISOC99_SOURCE
#endif
#ifndef _XOPEN_SOURCE
#define _XOPEN_SOURCE       600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE     200112L
#endif
@

<<set -I${HOME}/local/include>>=
if [ -d "${HOME}/local/include" ]; then
    set -- "$@" "-I${HOME}/local/include"
fi
@

<<set -L${HOME}/local/lib>>=
if [ -d "${HOME}/local/lib" ]; then
    set -- "$@" "-L${HOME}/local/lib"
fi
@

<<set -L${HOME}/local/lib64>>=
if [ -d "${HOME}/local/lib64" ]; then
    set -- "$@" "-L${HOME}/local/lib64"
fi
@

<<set -I and -L for ${HOME}/local>>=
<<set -I${HOME}/local/include>>
<<set -L${HOME}/local/lib>>
<<set -L${HOME}/local/lib64>>
@

<<also consider "${HOME}/local"?>>=
if [ x"${INCLUDE_HOME_LOCAL:-}" = x1 ]; then
    <<set -I and -L for ${HOME}/local>>
fi
@
