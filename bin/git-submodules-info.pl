#!/usr/bin/env perl

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use 5.008; # perl v5.8.0 was released on July 18, 2002
use strict;
use warnings FATAL => 'uninitialized';
use Carp ();
$SIG{__DIE__} = \&Carp::confess;

local $\ = "\n";

sub slurp_subprocess_lines {
    open(my $fh, '-|', @_) or die $!;
    if (wantarray) {
	my @res = map {chomp($_); $_} <$fh>;
	close($fh); # or Carp::carp "Cannot close $fh: $!";
	return @res;
    } elsif (defined(wantarray)) {
	my $res = do {local $/; <$fh>};
	close($fh); # or Carp::carp "Cannot close $fh: $!";
	return $res;
    }
    Carp::confess 'exhaustion';
}

sub set_many (\%@) {
    my ($h, $k, $v) = @_;
    if (defined($h->{$k})) {
	if (ref($h->{$k}) eq 'ARRAY') {
	    push(@{ $h->{$k} }, $v);
	} else {
	    $h->{$k} = [$h->{$k}, $v];
	}
    } else {
	$h->{$k} = $v;
    }
}

sub get_many {
    return @{ $_[0] } if ref($_[0]) eq 'ARRAY';
    @_;
}

sub read_configuration {
    my ($config, $regex) = @_;
    my @args = (qw{git config -f}, $config, '--get-regexp', $regex);
    my %res;
    set_many(%res, split(' ', $_, 2)) for slurp_subprocess_lines(@args);
    %res;
}

sub expand {
    map {$_[0]->{$_[1] . $_}} qw(.path .url .branch);
}

my $gitmodules = defined($ARGV[0]) ? $ARGV[0] : '-';

my $conf = { read_configuration($gitmodules, '^submodule\.') };

{
    my @mods = map {s,\.path$,,; $_} grep {/\.path$/} keys(%{$conf});
    for my $i (@mods){
	(my $id = $i) =~ s,^submodule\.,,;
        my ($path, $url, $branch) = expand($conf, $i);
        $branch = q{master} unless $branch;
	my ($urldn, $urlbn);
	if ($url =~ m{^\.\./.+}) {
	    # relative path
	    $urldn = $url;
	    $urlbn = $url;
	} elsif ($url =~ m{^(.*)/(.*)}) {
	    # uri-like
	    $urldn = $1;
	    $urlbn = $2;
	} else {
	    Carp::confess 'exhaustion';
	}
        print("$url $urldn $urlbn $branch $path $id");
    }
}
