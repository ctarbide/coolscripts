#!/bin/sh

set -eu

if [ x"${ZSH_VERSION:-}" != x ]; then
    # let zsh behave like dash, bash and others shells when
    # expanding parameters
    setopt sh_word_split
fi

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisprog=${thispath##*/}
thisdir=${thispath%/*}

test -d dups || die 1 "error: missing 'dups' directory"

if [ $# -lt 2 ]; then
    die 1 "usage: ${thisprog} file1 file2 [...]"
fi

# backup args before shifting then
args=; for arg do args="${args} '${arg}'"; done

first=${1}; shift
first_realpath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${first}"`
first_basename=${first##*/}

test -f "${first}" || die 1 "file \"${first}\" does not exist"
test ! -f "dups/${first_basename}" || die 1 "file \"dups/${first_basename}\" already exists"

while [ $# -gt 0 ]; do
    other=${1}; shift
    other_realpath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${other}"`
    other_basename=${other##*/}

    test x"${first_realpath}" != x"${other_realpath}" || die 1 "error: same file"

    test -f "${other}" || die 1 "error: file \"${other}\" does not exist"

    if ! cmp -s "${first}" "${other}"; then
        die 1 "error: files \"${first}\" and \"${other}\" differ"
    fi

    # move 'first' once, only after comparing with other
    if [ ! -f "dups/${first_basename}" ]; then
        echo "mv -vi '${first}' 'dups/${first_basename}'"
        echo "touch -r 'dups/${first_basename}' '${first}'"
    fi

    echo "truncate.pl '${other}'"
done	

echo ls -lh "${args} 'dups/${first_basename}'"

echo 'echo all done'
