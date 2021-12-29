#!/bin/sh

set -eux

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# consider symbolic link
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`

# consider real file path
# thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`

thisprog=${thispath##*/}
thisdir=${thispath%/*}
thisdirbasename=${thisdir##*/}
thisparentdir=${thisdir%/*}

# very useful for keyprefix--do-stuff.sh cases
# thisprefix=${thisprog%--*.sh}

cd "${thisdir}"

. ./config.inc.sh
. ./config_gcc-11.2.0.inc.sh

PATH=${PREFIX}/bin:${PATH}

MAKE=gmake
export MAKE

LD_LIBRARY_PATH=${PREFIX}/lib64:${LD_LIBRARY_PATH:-}
LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
export LD_LIBRARY_PATH

mkdir -p "${BUILD_DIR}"

################ sanity check

[ -f "${PREFIX}/lib/libgmp.la" ] || die 1 "error: dependency gmp not present"
[ -f "${PREFIX}/lib/libmpfr.la" ] || die 1 "error: dependency mpfr not present"
[ -f "${PREFIX}/lib/libmpc.la" ] || die 1 "error: dependency mpc not present"
[ -f "${PREFIX}/lib/libopcodes.la" ] || die 1 "error: dependency libopcodes (binutils) not present"
[ -f "${PREFIX}/lib/libbfd.la" ] || die 1 "error: dependency libbfd (binutils) not present"

which gperf >/dev/null || die 1 "error: program not found: gperf"

################ build gcc

[ -d "${GCC_BUILD_ROOT_DIR}" ] || extract_gcc

(
    set -eux
    cd "${GCC_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${GCC_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    if [ ! -x config.status ]; then
        # --enable-threads=posix
        # --disable-threads
        # --disable-libatomic
        # --disable-decimal-float
        # --disable-libquadmath
        ../configure --prefix="${GCC_PREFIX}" \
                     --with-gmp="${PREFIX}" \
                     --with-mpc="${PREFIX}" \
                     --with-mpfr="${PREFIX}" \
                     --disable-bootstrap \
                     --disable-libcilkrts \
                     --disable-libgomp \
                     --disable-libitm \
                     --disable-libsanitizer \
                     --disable-libssp \
                     --disable-libvtv \
                     --disable-multilib \
                     --disable-nls \
                     --disable-shared \
                     --disable-libcc1 \
                     --with-newlib \
                     --enable-__cxa_atexit \
                     --enable-languages=c,c++,lto
    fi
    if [ ! -x "${PREFIX}/bin/gcc" -o ! -f gcc/libgcc.a ]; then
        # force old gperf to regenerate cfns.h from the epoch (2013)
        # rm -fv ../gcc/cp/cfns.h   # not regenerated anymore? was in gcc-4
        ${MAKE}
        # ${MAKE} check   # error, missing 'autogen' in fixincludes, see screenshots
        ${MAKE} install
    fi
)

####

echo "all done for \"${0##*/}\""
