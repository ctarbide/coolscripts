#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

# note: this only show commands
#
# note: use a relative paths to current working directory
#
# usage: ./move-and-symlink.sh regular-file target-directory

regular_file=$1; shift
target_directory=$1; shift

test -f "${regular_file}" || die 1 "Error, first argument must be a regular file."
test -d "${target_directory}" || die 1 "Error, second argument must be an existing directory."

perl -wsle'
    $targetdir =~ s,/+$,,;
    (my $basename = $path) =~ s,^.*/,,;
    my $prefix = q{../} x scalar(($_ = $path) =~ tr,/,,);
    print qq{mv -vi \047${path}\047 \047${targetdir}/\047};
    print qq{ln -s \047${prefix}${targetdir}/${basename}\047 \047${path}\047};
' -- -path="${regular_file}" -targetdir="${target_directory}"
