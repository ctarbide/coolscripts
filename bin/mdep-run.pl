#!/usr/bin/env perl

# https://github.com/ctarbide/coolscripts

use strict;
use warnings FATAL => 'uninitialized';
use 5.010; # perl v5.10 was released on December 18, 2007
use Carp ();
$SIG{__DIE__} = \&Carp::confess;
use File::Spec::Functions qw(rel2abs canonpath);
use Cwd ();

local $| = 1; # 1=autoflush_on (turn off buffering)
local $\ = "\n";

my $mdepcp;

if ($ENV{MDEP_CLASSPATH}) {
    $mdepcp = $ENV{MDEP_CLASSPATH};
    die "file \"${mdepcp}\" does not exit." unless -f $mdepcp;
} else {
    my $workdir = Cwd::getcwd();
    my $adwts = $workdir . q{/}; # absolute dir with trailing slash
    my $adwts0;
    my $found;
    sub assign_if_notset_and_file_exists {
	$_[0] = $_[1] if not $_[0] and -f $_[1];
    }
    while (1) {
	assign_if_notset_and_file_exists($found, "${adwts}target/mdep-runtime.classpath");
	assign_if_notset_and_file_exists($found, "${adwts}target/mdep.classpath");
	assign_if_notset_and_file_exists($found, "${adwts}mdep-runtime.classpath");
	assign_if_notset_and_file_exists($found, "${adwts}mdep.classpath");
	last if $found or ($adwts eq '/');
        $adwts =~ s,/+$,,x;                # remove trailing slashes
        $adwts =~ s,^(.*)/.*?$,${1}/,x;    # rewind
    }
    $mdepcp = $found if $found;
}

die 'run "mvn -Dmdep.outputFile=target/mdep-runtime.classpath -DincludeScope=runtime -Dmdep.regenerateFile=true dependency:build-classpath" first.' unless $mdepcp;

my $cpsep = $^O eq 'linux' ? ':' : $^O eq 'MSWin32' ? ';' : die 'exhaustion';

my @cp;

if ($ENV{CLASSPATH}) {
    push(@cp, split($cpsep, $ENV{CLASSPATH}));
}

if (-d 'target/classes') {
    @cp = grep { !m{^target/classes$} } (@cp);
    push(@cp, canonpath(rel2abs('target/classes')));
}

$ENV{CLASSPATH} = join($cpsep, @cp, do {local (*ARGV, $/) = ([$mdepcp]); <>});

sub system_or_exec {
    if ($^O eq 'linux') {
	exec(@_);
    } elsif ($^O eq 'MSWin32') {
	system(@_);
    } else {
	die 'exhaustion';
    }
}

system_or_exec(@ARGV);
