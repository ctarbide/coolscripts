#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
use File::Spec;
$SIG{__DIE__} = \&Carp::confess;

my ($envdir, @cmd) = @ARGV;

sub assign_ifdef { $_[0] = $_[1] if defined($_[1]) }

assign_ifdef(my $chdir, $ENV{INPUT_FILE_DIR});

opendir(my $dh, $envdir) or Carp::croak("Cannot open $envdir: $!");

for my $key (grep{ !/^\./ }(readdir($dh))) {
    my $path = File::Spec->catfile($envdir, $key);
    next if -d $path;
    if (-s $path == 0) {
        delete($ENV{$key});
    } else {
        chomp(my $value = do {local (*ARGV) = ([$path]); scalar(<>)});
        $ENV{$key} = $value;
    }
}

closedir($dh) or Carp::carp "Cannot close $envdir: $!";

if (defined($chdir)) {
  die unless -d $chdir;
  chdir($chdir);
}
exec(@cmd);
