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

(
    set -eux
    test -d "${PREFIX}/bin" || mkdir -pv "${PREFIX}/bin"
    cd "${PREFIX}/bin"
    if [ ! -x make ]; then
        ln -s "`which gmake`" make
    fi
)

LD_LIBRARY_PATH=${PREFIX}/lib64:${LD_LIBRARY_PATH:-}
LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}
LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
export LD_LIBRARY_PATH

mkdir -p "${BUILD_DIR}"

################ build perl

[ -d "${PERL_BUILD_ROOT_DIR}" ] || extract_perl

(
    set -eux
    cd "${PERL_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${PERL_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    if [ ! -f config.h ]; then
        ../Configure -Dmksymlinks -de -Dprefix="${PREFIX}"
    fi
    if [ ! -f "${PREFIX}/bin/perl" -o ! -f x2p/a2p ]; then
        ${MAKE}
        # ${MAKE} test
        ${MAKE} install
    fi
)

################ build m4

[ -d "${M4_BUILD_ROOT_DIR}" ] || extract_m4

(
    set -eux
    cd "${M4_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${M4_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/m4" ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build autoconf

[ -d "${AUTOCONF_BUILD_ROOT_DIR}" ] || extract_autoconf

(
    set -eux
    cd "${AUTOCONF_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${AUTOCONF_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/autoconf" ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build automake

[ -d "${AUTOMAKE_BUILD_ROOT_DIR}" ] || extract_automake

(
    set -eux
    cd "${AUTOMAKE_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${AUTOMAKE_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/automake" ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build libtool

[ -d "${LIBTOOL_BUILD_ROOT_DIR}" ] || extract_libtool

(
    set -eux
    cd "${LIBTOOL_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${LIBTOOL_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/libtool" ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build gperf

[ -d "${GPERF_BUILD_ROOT_DIR}" ] || extract_gperf

(
    set -eux
    cd "${GPERF_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${GPERF_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/gperf" ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build texinfo

[ -d "${TEXINFO_BUILD_ROOT_DIR}" ] || extract_texinfo

(
    set -eux
    cd "${TEXINFO_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${TEXINFO_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}"
    if [ ! -x "${PREFIX}/bin/makeinfo" -o ! -f tp/texi2any ]; then
        ${MAKE}
        # ${MAKE} check
        ${MAKE} install
    fi
)

################ build gmp

[ -d "${GMP_BUILD_ROOT_DIR}" ] || extract_gmp

(
    set -eux
    cd "${GMP_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${GMP_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}" --disable-shared
    if [ ! -f "${PREFIX}/lib/libgmp.la" -o ! -f libgmp.la ]; then
        ${MAKE}
        ${MAKE} check
        ${MAKE} install
    fi
)

################ build mpfr

[ -d "${MPFR_BUILD_ROOT_DIR}" ] || extract_mpfr

(
    set -eux
    cd "${MPFR_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${MPFR_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    if [ ! -x config.status ]; then
        # --with-gmp-include=DIR  GMP include directory
        # --with-gmp-lib=DIR      GMP lib directory
        # --with-gmp=DIR          GMP install directory
        ../configure --prefix="${PREFIX}" --disable-shared \
                     --enable-gmp-internals \
                     --with-gmp-build="${GMP_BUILD_ROOT_DIR}/build"
    fi
    if [ ! -f "${PREFIX}/lib/libmpfr.la" -o ! -f src/libmpfr.la ]; then
        ${MAKE}
        ${MAKE} check
        ${MAKE} install
    fi
)

################ build mpc

[ -d "${MPC_BUILD_ROOT_DIR}" ] || extract_mpc

(
    set -eux
    cd "${MPC_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${MPC_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    if [ ! -x config.status ]; then
        ../configure --prefix="${PREFIX}" --disable-shared \
                     --with-gmp="${PREFIX}" \
                     --with-mpfr="${PREFIX}"
    fi
    if [ ! -f "${PREFIX}/lib/libmpc.la" -o ! -f src/libmpc.la ]; then
        ${MAKE}
        ${MAKE} check
        ${MAKE} install
    fi
)

################ build binutils

[ -d "${BINUTILS_BUILD_ROOT_DIR}" ] || extract_binutils

(
    set -eux
    cd "${BINUTILS_BUILD_ROOT_DIR}"
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m"initial commit from version ${GMP_VERSION}"
        rm -fv .git/hooks/*.sample
        git repack -d
        git prune
    fi
    mkdir -p build
    cd build
    [ -x config.status ] || ../configure --prefix="${PREFIX}" --disable-shared
    if [ ! -x "${PREFIX}/bin/ar" -o ! -f "ld/ldmain.o" ]; then
        ${MAKE}
        ${MAKE} check
        ${MAKE} install
    fi
)

####

echo "all done for \"${0##*/}\""
