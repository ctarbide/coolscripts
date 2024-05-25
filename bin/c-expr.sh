#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .c --tmp-- .out
SH=${SH:-sh -eu}; export SH
CC=${CC:-gcc}; export CC
LDFLAGS=${LDFLAGS:-}; export LDFLAGS
if [ x"${SOURCE_IN_STDIN:-}" = x1 ]; then
    exec nofake-exec.sh --error -R'prog stdin' "$@" --tmp-- _in.nw -- ${SH}
else
    exec nofake-exec.sh --error -R'prog snippet' "$@" -- ${SH}
fi
exit 1

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
    <<snippet>>
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
<<c standards>>
<<includes>>
<<definitions>>
<<types>>
<<globals>>
<<protos>>
<<impl>>
@

<<includes>>=
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
@

<<prog snippet>>=
<<prog preamble>>
if ! nofake-exec.sh --error -L -R'c source - snippet' -o"${0}.c" "$@"; then
    show-line-numbers.sh "${0}.c"
    exit 1
fi
eval "set -- ${saveargs}"
[ -t 0 ] && exec 0>&-
"${0}.out" "$@"
@

<<prog stdin>>=
<<prog preamble>>
<<function escape_chunk>>
printf -- '@<<stdin>>=\n' >"${0}_in.nw"
cat | escape_chunk >>"${0}_in.nw"
exec 0>&-
if ! nofake-exec.sh --error -L -R'c source - stdin' -o"${0}.c" "${0}_in.nw" "$@"; then
    show-line-numbers.sh "${0}.c"
    exit 1
fi
eval "set -- ${saveargs}"
"${0}.out" "$@"
@

<<function escape_chunk>>=
escape_chunk(){
    perl -lpe's,^\@($| ),\@\@${1},; s,([^\@])@<<,${1}\@@<<,g'
}
@

<<prog preamble>>=
<<function cmd_push_to_argv>>
thisprog=${1}; shift # the initial script
saveargs=`for arg; do printf -- " '%s'" "${arg}"; done`
set -- "${thisprog}"
if [ x"${ADDITIONAL_SOURCES:-}" != x ]; then
    set_add_srcs=`echo "${ADDITIONAL_SOURCES:-}" | cmd_push_to_argv`
    eval "${set_add_srcs}"
fi
set -- "$@" -- ${CC}
<<set CFLAGS>>
set -- "$@" ${LDFLAGS} -o"${0}.out"
@

<<function cmd_push_to_argv>>=
cmd_push_to_argv(){
    normalize-args.sh | perl -lpe'$_=qq{set -- \042\$\@\042 ${_};}' |
        LC_ALL=C sort -u
}
@

<<set CFLAGS>>=
<<set CFLAGS - pedantic>>
@

<<set CFLAGS - pedantic>>=
set -- "$@" -O2 -ansi -pedantic
set -- "$@" -Wall -Wextra -Wstrict-prototypes -Wmissing-prototypes
set -- "$@" -Wshadow -Wconversion -Wdeclaration-after-statement
set -- "$@" -Wno-unused-parameter
set -- "$@" -Werror -fmax-errors=3
@

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
#define _XOPEN_SOURCE		600
#endif
#ifndef _POSIX_C_SOURCE
#define _POSIX_C_SOURCE		200112L
#endif
@
