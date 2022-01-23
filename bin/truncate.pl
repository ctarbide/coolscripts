#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

for my $fname (@ARGV) {
    my ($st_def, $st_ino, $st_mode, $st_nlink,
        $st_uid, $st_gid, $st_rdev, $st_size,
        $st_atime, $st_mtime, $st_ctime) = stat($fname);
    truncate($fname, 0);
    utime($st_atime, $st_mtime, $fname);
}
