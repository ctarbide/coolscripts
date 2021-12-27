#!/bin/sh

# usage: run_gcc-11.2.0.sh ./build_rlwrap.sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisprog=${thispath##*/}
thisdir=${thispath%/*}
thisdirbasename=${thisdir##*/}
thisparentdir=${thisdir%/*}

project_name=${thisprog#build_}
project_name=${project_name%.sh}

build_dir=${HOME}/Ephemeral/build/${project_name}
prefix=${HOME}/local

git_archive_prefix=${project_name}-git/

#dist=${thisdir}/bison-3.8.2.tar.lz
#version=${dist##*/}
#build_dir_default=${build_dir}/bison-3.8.2

build_dir_default=${build_dir}/${project_name}-git
git_repos=${thisdir}/hanslub42_rlwrap.git
branch=master
version=${branch}

mkdir -pv "${build_dir}"

stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`

# git archive --remote="${git_repos}" --format=tar --prefix="${git_archive_prefix}" "${branch}" | xz -9 > "${project_name}_"${branch}"_${stamp}.tar.xz"
# die 1 exported

if [ ! -d "${build_dir_default}" ]; then
    if [ x"${git_repos:-}" != x ]; then
        # git archive --remote="${git_repos}" --format=tar --prefix="${git_archive_prefix}" "${branch}" | tar -C "${build_dir}" -xf -
        git clone -b "${branch}" "${git_repos}" "${build_dir_default}"
    else
        cat.sh "${dist}" | tar -C "${build_dir}" -xf -
    fi
fi

cd "${build_dir_default}"

if [ ! -d .git -o -f .git/verifying ]; then
    git init
    echo "${stamp}" > .git/verifying
    git checkout -b "build__${stamp}"
    git-ctarbide-set-credentials.sh
    git add -f .
    git commit -m"initial commit from ${version}"
    rm -fv .git/hooks/*.sample
    git repack -d
    git prune
    if [ x"${git_repos:-}" != x ]; then
        git remote add origin "${git_repos}"
    fi
    rm -fv .git/verifying
fi

# MAKE=bmake
MAKE=gmake
export MAKE

PKG_CONFIG=`which ppkg-config`
export PKG_CONFIG

PKG_CONFIG_PATH=/usr/lib/pkgconfig${PKG_CONFIG_PATH:+:${PKG_CONFIG_PATH}}
PKG_CONFIG_PATH=/usr/lib64/pkgconfig:${PKG_CONFIG_PATH}
PKG_CONFIG_PATH=/usr/share/pkgconfig:${PKG_CONFIG_PATH}
PKG_CONFIG_PATH=${prefix}/lib/pkgconfig:${PKG_CONFIG_PATH}
PKG_CONFIG_PATH=${prefix}/lib64/pkgconfig:${PKG_CONFIG_PATH}
export PKG_CONFIG_PATH

do_cmake(){
    mkdir -p build
    cd build
    if [ ! -f CMakeCache.txt ]; then
        cmake -G "Unix Makefiles" \
            -DCMAKE_MAKE_PROGRAM="${MAKE}" \
            -DCMAKE_INSTALL_PREFIX="${prefix}" \
            -DPKG_CONFIG_EXECUTABLE="${PKG_CONFIG}" \
            ..
    fi
    "${MAKE}"
    "${MAKE}" install
}

do_autotools(){
    boostrap_autotools(){
        if [ -f configure.ac -a ! -x configure ]; then
            # docker-cwd.sh --rm docker.io/library/buildpack-deps:sid autoreconf -fiv
            autoreconf -fiv
        fi
    }

    do_configure(){
        # ../configure --prefix="${prefix}"
        ./configure --prefix="${prefix}"
    }

    # better have these handy all the time when dealing with autotools
    which m4 >/dev/null 2>/dev/null || die 1 "m4 not in path?"
    which autoconf >/dev/null 2>/dev/null || die 1 "autoconf not in path?"
    which automake >/dev/null 2>/dev/null || die 1 "automake not in path?"
    which libtool >/dev/null 2>/dev/null || die 1 "libtool not in path?"

    boostrap_autotools

    # mkdir -p build
    # cd build

    if [ ! -x config.status ]; then
        if ! do_configure; then
            rm -fv config.status
            die 1 "error: configure failed"
        fi
    fi

    if [ ! -x "${prefix}/bin/rlwrap" ]; then
        "${MAKE}"
        # "${MAKE}" check
        "${MAKE}" install
    fi
}

do_interactive(){
    RPS1='%F{red}*** BUILDING '"${project_name}"' ***%f'
    export RPS1
    exec run_gcc-11.2.0.sh zsh
}

do_custom(){
    cd AStyle/build/gcc
    gmake
    cp -av bin/astyle "${prefix}/bin"
}

do_autotools
# do_cmake
# do_interactive
# do_custom

echo "all done for ${0##*/}"
