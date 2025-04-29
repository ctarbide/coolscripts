#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .c --tmp-- .out
SH=${SH:-sh -eu}; export SH
CC=${CC:-gcc}; export CC
exec nofake-exec.sh --error -Rprog "$@" --tmp-- _aux.nw -- ${SH}
exit 1

nofake -R'usage example' rtt-aux.sh

<<usage example>>=
#!/bin/sh
set -eu
:>aux.nw
c-expr_c_standards.sh 'rtt-aux c standards' >>aux.nw
c-expr_includes.sh 'rtt-aux includes' >>aux.nw
./rtt-aux.sh | nofake --error -Rrtt aux.nw - |
    __RTT_PURE_C__=1 rtt -x -D__RTT__=1 -D__RTT_PURE_C__=1 \
        -D__RTT_OUTPUT='"/dev/stdout"' -
@

<<prog>>=
thisprog=${1}; shift # the initial script
:>"${0}_aux.nw"
cat "${0}_aux.nw"
tail_start_line=`perl -lne'next unless m{^@<<rtt>>=$};print$.;last' "${thisprog}"`
tail "+${tail_start_line}" "${thisprog}"
@

tail output starts below this line

<<rtt>>=
#ifndef __RTT__
#error "Not using rtt?"
#endif

#define __STDC__ 1
#define __STDC_VERSION__ 199901L

<<rtt-aux c standards>>

typedef IGNORE __builtin_va_list;
typedef IGNORE va_list;
typedef IGNORE _Bool;

#define __PT__va_arg(_1, _2) passthru(va_arg(_1, passthru(_2)))

#define __PT__fpclassify(x) passthru(fpclassify(passthru(x)))
#define __PT__isinf(x)      passthru(     isinf(passthru(x)))
#define __PT__isnan(x)      passthru(     isnan(passthru(x)))
#define __PT__isnormal(x)   passthru(  isnormal(passthru(x)))
#define __PT__isfinite(x)   passthru(  isfinite(passthru(x)))

#define __attribute__(x)

#define restrict
#define inline

<<rtt-aux includes>>

#undef va_arg
#define va_arg(_1, _2) __PT__va_arg(_1, _2)

<<noexpand>>

#output __RTT_OUTPUT

#passthru "definitions" #define __GENERATED_FROM_RTT 1
@

<<noexpand>>=
#noexpand __FILE__
#noexpand __LINE__
#ifdef INFINITY
#noexpand INFINITY
#endif
@
