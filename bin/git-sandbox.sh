#!/bin/sh

# git-sandbox.sh is a "side-car" repository, very useful for not
# tainting the official repository

# usage:
# git-sandbox.sh
# git-sandbox.sh add <file>
# git-sandbox.sh status
# git-sandbox.sh ls
# git-sandbox.sh diff
# git-sandbox.sh diff -w
# git-sandbox.sh add
# git-sandbox.sh commit <message>

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

abs_canon_path(){
    perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs($ARGV[0])))' -- "$1"
}

# modified files
files_m(){
    git status --porcelain -uno -- "$@" | perl -lne'next unless m{^(?:[ AM][M ]|RM .*? ->) (.*)}; print($1)'
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
    echo 'git-sandbox repository does not exist yet, create a new one? ("yes" to confirm)'
    read ans
    if [ x"${ans}" != xyes ]; then
        echo 'aborting'
        exit
    fi
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

        status of added or modified files

    ${0##*/} ls

        listing of all known files

    ${0##*/} commit

        commit changes without a message, repack all and prune

    ${0##*/} commit message

        commit changes with a custom message

    ${0##*/} (log|show|diff|status|ls-files) [...]
    ${0##*/} (add|checkout|mv|rm) [...]

        bypassed as-is to git

EOF
    cd "${GIT_WORK_TREE}" && files_m | xargs -r git status
    exit 1
fi

protect_add_command(){
    for arg in "$@"; do
        case "${arg}" in
            -f) ;; # .gitignore shouldn't be in git-sandbox's way
            -*)
                die 1 "ERROR: Use exec command for explicit git commands."
                ;;
        esac
    done
}

case "${#}_${1}" in
    1_add)
        cd "${GIT_WORK_TREE}" && files_m | xargs -r git add -f
        ;;
    2_add)
        case "${2}" in
            -u)
                # 'git add -u' has the ability to stage deleted files,
                # this don't match well with git-sandbox.sh intended
                # purpose/workflow, for explicit commands use 'exec'
                # instead of 'add'
                cd "${GIT_WORK_TREE}" && files_m | xargs -r git add
                ;;
            *)
                git add "${2}"
                ;;
        esac
        ;;
    1_status | 1_diff)
        cd "${GIT_WORK_TREE}" && files_m | xargs -r git "$@"
        ;;
    2_status)
        case "${2}" in
            . | ..)
                files_m "${2}" | (cd "${GIT_WORK_TREE}" && xargs -r git status)
                ;;
            *)
                git status "${2}"
                ;;
        esac
        ;;
    2_diff)
        case "${2}" in
            . | ..)
                files_m "${2}" | (cd "${GIT_WORK_TREE}" && xargs -r git diff)
                ;;
            -w | --cached)
                files_m | (cd "${GIT_WORK_TREE}" && xargs -r git "$@")
                ;;
            *)
                git diff "${2}"
                ;;
        esac
        ;;
    1_ls)
        exec git ls-files
        ;;
    1_commit)
        git commit --allow-empty-message -m ""
        git repack -da
        git prune
        ;;
    2_commit)
        case "${2}" in
            -*)
                die 1 "the second argument to 'commit' is the commit message, not a flag"
                ;;
        esac
        exec git commit -m "${2}"
        ;;
    *_add)
        cmd=$1; shift
        protect_add_command "$@"
        exec git "${cmd}" "$@"
        ;;
    *_commit | *_log | *_show | *_status | *_ls-files | *_checkout | *_mv | *_rm | *_repack | *_prune | *_fsck | *_reset | *_restore | *_diff)
        cmd=$1; shift
        exec git "${cmd}" "$@"
        ;;
    *_gitk)
        shift
        exec gitk "$@"
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
