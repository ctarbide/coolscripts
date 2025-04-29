#!/bin/sh
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .c --tmp-- .out
SH=${SH:-sh -eu}; export SH
CC=${CC:-gcc}; export CC
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

This script is specific for gcc, other compilers are also provided with
different scripts.

<<prog>>=
<<function die>>
<<function simple_chunk>>
<<function cpp>>
<<function test_inclusion>>

uname_srm=`uname -srm`
if [ x"${uname_srm}" = x ]; then
    die 1 "Failed to identify the current system." >&2
fi

compiler_name=gcc

compiler_path=`command -v "${CC}"`
if [ x"${compiler_path}" = x ]; then
    die 1 "compiler \"${CC}\" not found"
fi

compiler_version_major=`echo __GNUC__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_major}" = x"__GNUC__" ]; then
    die 1 "Failed to determine ${compiler_name} major version." >&2
fi

compiler_version_minor=`echo __GNUC_MINOR__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_minor}" = x"__GNUC_MINOR__" ]; then
    die 1 "Failed to determine ${compiler_name} minor version." >&2
fi

compiler_version_patchlevel=`echo __GNUC_PATCHLEVEL__ | "${compiler_path}" -E -P -x c -`
if [ x"${compiler_version_patchlevel}" = x"__GNUC_PATCHLEVEL__" ]; then
    die 1 "Failed to determine ${compiler_name} patchlevel version." >&2
fi

simple_chunk 'uname -srm' "${uname_srm}"
simple_chunk 'compiler name' "${compiler_name}"
simple_chunk 'compiler path' "${compiler_path}"
simple_chunk 'compiler version major' "${compiler_version_major}"
simple_chunk 'compiler version minor' "${compiler_version_minor}"
simple_chunk 'compiler version patchlevel' "${compiler_version_patchlevel}"
simple_chunk CFLAGS "${CFLAGS}"

<<list include directories>>
<<list compiler predefines>>
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

<<list compiler predefines>>=
printf -- '@<<compiler predefines>>=\n'
echo | "${compiler_path}" ${CFLAGS} -dM -E -
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
set -- "$@" sys/param.h
set -- "$@" sys/socket.h
@

<<analyse headers>>=
(
    set --
    <<headers of interest>>
    for hdr; do
       test_inclusion "${hdr}"
    done
) | perl -wle'
    my ($hdr, $path, @incdirs, %found);
    while (<>) {
        chomp;
        s,\015+$,,;
        if (($hdr, $path) = m{^found \047(.+?)\047 at \047(.+?)\047$}) {
            (my $dir = $path) =~ s,/\Q${1}\E$,,;
            print qq{@<<headers found>>=};
            <<append $hdr to args>>
            push(@incdirs, $dir) unless $found{$dir}++;
            next;
        }
        if (($hdr) = m{^not found \047(.+?)\047$}) {
            print qq{@<<headers not found>>=};
            <<append $hdr to args>>
            next;
        }
        # just ignore unknown cases
        print STDERR qq{exhaustion \047${_}\047};
    }
    print qq{@}' | nofake-coalesce.pl
@

<<list include directories>>=
printf -- '@<<include directories>>=\n'
echo | "${compiler_path}" ${CFLAGS} -E -v -x c - 2>&1 | perl -wslne'
    next unless m{^ \s (/[\w/\-.]+) $}xi;
    print qq{set -- "\$\@" \047${1}\047;};
    $c++;
}{die qq{Error, no include directories found.} unless $c' -- -c=0
@

<<append $hdr to args>>=
print qq{set -- "\$\@" \047${hdr}\047;};
@

<<function cpp>>=
cpp(){
    printf -- '#include <%s>\n' "${1}" | "${compiler_path}" ${CFLAGS} \
        -E -x c - 2>/dev/null
}
@

<<function test_inclusion>>=
test_inclusion(){
    suffix=${1#../}
    cpp "${1}" | perl -slne'
        next unless m{^\# \s \d+ \s " (.+?) "}xi;
        next unless rindex($1, $suffix) >= 0;
        print qq{found \047${suffix}\047 at \047${1}\047};
        exit 0;
    }{
        print qq{not found \047${suffix}\047} unless keys %found;
    ' -- -suffix="${suffix}"
}
@
