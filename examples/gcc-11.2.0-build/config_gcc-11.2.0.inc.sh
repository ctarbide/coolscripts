
GCC_VERSION=11.2.0

BUILD_DIR=${HOME}/Ephemeral/build/gcc-${GCC_VERSION}_build
PREFIX=${HOME}/Ephemeral/gcc-releases/${GCC_VERSION}

################ perl

# automake requires perl

PERL_VERSION=5.16.3
PERL_BUILD_ROOT_DIR=${BUILD_DIR}/perl-${PERL_VERSION}
PERL_DIST=${GCC_DIST_HOME}/perl-${PERL_VERSION}.tar.bz2

extract_perl(){ extract "${PERL_DIST}" "${BUILD_DIR}"; }

################ m4

M4_VERSION=1.4.6
M4_BUILD_ROOT_DIR=${BUILD_DIR}/m4-${M4_VERSION}
M4_DIST=${GCC_DIST_HOME}/m4-${M4_VERSION}.tar.bz2

extract_m4(){ extract "${M4_DIST}" "${BUILD_DIR}"; }

################ autoconf

AUTOCONF_VERSION=2.69
AUTOCONF_BUILD_ROOT_DIR=${BUILD_DIR}/autoconf-${AUTOCONF_VERSION}
AUTOCONF_DIST=${GCC_DIST_HOME}/autoconf-${AUTOCONF_VERSION}.tar.xz

extract_autoconf(){ extract "${AUTOCONF_DIST}" "${BUILD_DIR}"; }

################ automake

AUTOMAKE_VERSION=1.15
AUTOMAKE_BUILD_ROOT_DIR=${BUILD_DIR}/automake-${AUTOMAKE_VERSION}
AUTOMAKE_DIST=${GCC_DIST_HOME}/automake-${AUTOMAKE_VERSION}.tar.xz

extract_automake(){ extract "${AUTOMAKE_DIST}" "${BUILD_DIR}"; }

################ libtool

LIBTOOL_VERSION=2.4.6
LIBTOOL_BUILD_ROOT_DIR=${BUILD_DIR}/libtool-${LIBTOOL_VERSION}
LIBTOOL_DIST=${GCC_DIST_HOME}/libtool-${LIBTOOL_VERSION}.tar.gz

extract_libtool(){ extract "${LIBTOOL_DIST}" "${BUILD_DIR}"; }

################ gperf

GPERF_VERSION=3.0.4
GPERF_BUILD_ROOT_DIR=${BUILD_DIR}/gperf-${GPERF_VERSION}
GPERF_DIST=${GCC_DIST_HOME}/gperf-${GPERF_VERSION}.tar.gz

extract_gperf(){ extract "${GPERF_DIST}" "${BUILD_DIR}"; }

################ texinfo

TEXINFO_VERSION=5.2
TEXINFO_BUILD_ROOT_DIR=${BUILD_DIR}/texinfo-${TEXINFO_VERSION}
TEXINFO_DIST=${GCC_DIST_HOME}/texinfo-${TEXINFO_VERSION}.tar.xz

extract_texinfo(){ extract "${TEXINFO_DIST}" "${BUILD_DIR}"; }

################ gmp

GMP_VERSION=6.1.0
GMP_BUILD_ROOT_DIR=${BUILD_DIR}/gmp-${GMP_VERSION}
GMP_DIST=${GCC_DIST_HOME}/gmp-${GMP_VERSION}.tar.bz2

extract_gmp(){ cat.sh "${GMP_DIST}" | tar -C "${BUILD_DIR}" -xf -; }

################ mpfr

MPFR_VERSION=3.1.6
MPFR_BUILD_ROOT_DIR=${BUILD_DIR}/mpfr-${MPFR_VERSION}
MPFR_DIST=${GCC_DIST_HOME}/mpfr-${MPFR_VERSION}.tar.bz2

extract_mpfr(){ cat.sh "${MPFR_DIST}" | tar -C "${BUILD_DIR}" -xf -; }

################ mpc

MPC_VERSION=1.0.3
MPC_BUILD_ROOT_DIR=${BUILD_DIR}/mpc-${MPC_VERSION}
MPC_DIST=${GCC_DIST_HOME}/mpc-${MPC_VERSION}.tar.gz

extract_mpc(){ cat.sh "${MPC_DIST}" | tar -C "${BUILD_DIR}" -xf -; }

################ binutils

BINUTILS_VERSION=2.37
BINUTILS_BUILD_ROOT_DIR=${BUILD_DIR}/binutils-${BINUTILS_VERSION}
BINUTILS_DIST=${GCC_DIST_HOME}/binutils-${BINUTILS_VERSION}.tar.lz

extract_binutils(){ extract "${BINUTILS_DIST}" "${BUILD_DIR}"; }

################ gcc

GCC_BUILD_ROOT_DIR=${BUILD_DIR}/gcc-${GCC_VERSION}
GCC_DIST=${GCC_DIST_HOME}/gcc-${GCC_VERSION}.tar.xz
GCC_PREFIX=${PREFIX}_gcc

extract_gcc(){ cat.sh "${GCC_DIST}" | tar -C "${BUILD_DIR}" -xf -; }

################
