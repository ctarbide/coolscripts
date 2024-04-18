#!/bin/sh

# reference: centos7uberbuilder/run-devtoolset-9.sh

set -eu #x

FEH_OPTS=${FEH_OPTS:-}
export FEH_OPTS

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

LC_ALL=C
export LC_ALL

sep_char=`printf '\035'` # \035 is GS, quasi-arbitrarily chosen, see
                         # 'man ascii'

if [ x"${ZSH_VERSION:-}" != x ]; then
    # let zsh behave like dash, bash and others shells when expanding
    # parameters
    setopt sh_word_split
fi

has_filelist=

args0=
while [ "$#" -gt 0 -a x"${1:-}" != x-- ]; do
    if [ x"${1}" = x--filelist -o x"${1}" = x-f ]; then
        has_filelist=1
    fi
    args0=${args0}${sep_char}${1}
    shift
done
args0=${args0#${sep_char}}

if [ x"${1:-}" = x-- ]; then
    shift # shift '--'
    if [ "$#" -eq 0 -a x"${has_filelist}" = x ]; then
        # has only args0
        die 1 "error: no input files"
    fi
elif [ x"${args0}" != x ]; then
    # args0 -> "$@"
    oldIFS=${IFS}
    IFS=${sep_char}
    set -- ${args0}
    IFS=${oldIFS}
    args0= # moved to "$@"
else
    # has no args
    die 1 "error: no input files"
fi

echo 'preloading files to filesystem cache'

# preload first 300
find "$@" -type f | sort | head -n300 | perl -l0 -pe1 | xargs -r0 sha1sum >/dev/null

# preload last 500
find "$@" -type f | sort | tail -n500 | perl -l0 -pe1 | xargs -r0 sha1sum >/dev/null

echo showing

if [ x"${args0}" != x ]; then
    # unshift 'feh' arguments
    oldIFS=${IFS}
    IFS=${sep_char}
    set -- ${args0} "$@"
    IFS=${oldIFS}
fi

exec feh ${FEH_OPTS} -. -d -G --on-last-slide hold \
     --action 'echo "you pressed return, right?"' \
     --action1 'echo -n "move: "; mv-to-cwd-let-no-spaces-nor-colon.sh %F .' \
     --action2 'echo -n "copy: "; cp-to-cwd-let-no-spaces-nor-colon.sh %F .' \
     --action3 'rename-let-no-spaces-nor-colon.sh %F' \
     --action5 'ls -lh %F' \
     --action6 'locate -b %N' \
     --action7 'gimp %F' \
     --action8 'echo -n move:; mv -v %F .' \
     --action9 'echo -n copy:; cp -av %F .' \
     "$@"
