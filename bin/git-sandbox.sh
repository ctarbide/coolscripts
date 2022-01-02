#!/bin/sh

# git-sandbox.sh git status -uno

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

abs_canon_path(){
    perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs($ARGV[0])))' -- "$1"
}

# modified files
files_m(){
    git status --porcelain -uno | awk '/^.M/{print$2}'
}

GIT_DIR=`git-dir.sh .`

if [ x"${GIT_DIR}" = x ]; then
    die 1 "error: couldn't find GIT_DIR"
fi

real_git_dir=`abs_canon_path "${GIT_DIR}"`

GIT_WORK_TREE=${real_git_dir%/*}
GIT_DIR=${GIT_WORK_TREE}__git-sandbox

export GIT_DIR GIT_WORK_TREE

if [ ! -d "${GIT_DIR}/refs" ]; then
    git init
    rm -f "${GIT_DIR}"/hooks/*.sample
fi

if [ x"$*" = x ]; then
    cat<<EOF
useful commands:

    ${0##*/} add

        add only modified files

    ${0##*/} diff

        diff only modified files

    ${0##*/} status

        status of all known files

    ${0##*/} ls

        listing of all known files

    ${0##*/} commit

        commit changes with a default message

    ${0##*/} commit message

        commit changes with a custom message

    ${0##*/} (log|show|diff|status) [...]
    ${0##*/} (add|checkout|mv|rm) [...]

        bypassed as-is to git

EOF
    files_m | xargs -r git status
    exit 1
fi

protect_command(){
    for arg in "$@"; do
        case "${arg}" in
            -*)
                die 1 "ERROR: Use exec command for explicit git commands."
                ;;
        esac
    done
}

case "${#}_${1}" in
    1_add)
        files_m | xargs -r git add
        ;;
    1_diff)
        files_m | xargs -r git diff
        ;;
    1_status)
        exec git status -uno
        ;;
    1_ls)
        exec git ls-files
        ;;
    1_commit)
        exec git commit -m "checkpoint"
        ;;
    2_commit)
        exec git commit -m "${2}"
        ;;
    *_add)
        cmd=$1
        shift
        # 'git add -u' has the ability to stage/confirm deleted files, this
        # don't match nicely with git-sandbox.sh intended workflow
        protect_command "$@"
        exec git "${cmd}" "$@"
        ;;
    *_commit | *_log | *_show | *_diff | *_status | *_checkout | *_mv | *_rm)
        cmd=$1
        shift
        exec git "${cmd}" "$@"
        ;;
    *_exec) # yeahh.. easter egg, use with care
        shift
        exec "$@"
        ;;
    *)
        n=$#
        die 1 "ERROR: Unknown command \"${1}\" with $((n-1)) arguments."
        ;;
esac
