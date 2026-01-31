#!/usr/bin/env perl
# automatically generated from extract-and-normalize.nw, nofake.nw and
# normalize-args.nw
eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;
use 5.006; # perl v5.6.0 was released on March 22, 2000
use strict;
use warnings FATAL => qw{uninitialized void inplace};
use Carp ();
use CGI::Util qw{unescape};
local $\ = "\n";
my $carp_or_croak = \&Carp::carp;
sub set_many (\%@) {
    my ($h, $k, @rest) = @_;
    if (defined($h->{$k})) {
        if (ref($h->{$k}) eq 'ARRAY') {
            push(@{ $h->{$k} }, @rest);
        } else {
            $h->{$k} = [$h->{$k}, @rest];
        }
    } elsif (@rest > 1) {
        $h->{$k} = [ @rest ];
    } elsif (@rest) {
        $h->{$k} = $rest[0];
    } else {
        Carp::carp("no value specified");
    }
}
sub get_many {
    # () yield undef in scalar context

    # return () instead of (undef)
    return () unless defined($_[0]);

    # return @{arg}
    return @{ $_[0] } if ref($_[0]) eq 'ARRAY';

    # return (arg)
    @_;
}
my @outputlines = ();
my $lineformat = '#line %L "%F"%N';

# do not emit #line directives
my $sync = 0;

# hash tables for chunks and chunks options
my %chunks = ();
my %chunks_options = ();

my $list_roots = 0;
my %being_extracted = ();
sub extract {
    my ($prefix, $parent_fname, $parent_lnum, $chunk) = @_;
    if ($being_extracted{$chunk}) {
        Carp::croak("ERROR: Code chunk <<$chunk>> is used in its" .
            " own definition (at ${parent_fname}:${parent_lnum}).");
    }
    $being_extracted{$chunk}++;
    $chunks_options{$chunk}->{nextractions}++;
    my @res = ();
    my @input = get_many($chunks{$chunk});
    unless (@input) {
        $carp_or_croak->(
            "WARNING: Code chunk <<${chunk}>> is empty" .
            " (at ${parent_fname}:${parent_lnum}).");
    }
    if ($list_roots and @input) {
        $chunks{$chunk} = [$input[0], $input[1], ""];
    }
    my $fname_previous = '';
    my $lnum_previous = -1;
    while (my ($fname, $lnum, $line) = splice(@input, 0, 3)) {
        if ($sync) {
            if ($fname ne $fname_previous or $lnum != $lnum_previous + 1) {
                my $linenum = [0, $fname, $lnum];
                if (@res and ref($res[-1]) eq 'ARRAY') {
                    push(@{ $res[-1] }, $linenum);
                } else {
                    push(@res, [$linenum]);
                }
            }
            $fname_previous = $fname;
            $lnum_previous = $lnum;
        }
        my $found_chunk_ref;
        for (;;) {
            $found_chunk_ref = ($line =~ m{^ (|.*?[^\@]) << (.*?[^\@]) >> (|[^>].*?) $}x);
            if ($found_chunk_ref) {
                $lnum_previous = -1;
                my $before = $1;
                my $chunkref = $2;
                my $after = $3;
                if ($chunks_options{$chunkref}) {
                    my $line_new = undef;
                    my @chunkreflines = extract($prefix . $before, $fname,
                        $lnum, $chunkref);
                    while (@chunkreflines and ref($chunkreflines[0]) eq 'ARRAY') {
                        # propagate special items early, before processing lines
                        my @chunkspecials = @{ shift(@chunkreflines) };
                        if (@res and ref($res[-1]) eq 'ARRAY') {
                            push(@{ $res[-1] }, @chunkspecials);
                        } else {
                            push(@res, [ @chunkspecials ]);
                        }
                    }
                    if (@chunkreflines > 1) {
                        # case: many lines
                        my $indent;
                        my $before_has_content = $before !~ m{^\s*$};
                        if ($before_has_content) {
                            ($indent = $before) =~ s,[^\s], ,g;
                        } else {
                            $indent = $before;
                        }
                        my $first = shift(@chunkreflines);
                        my $last = pop(@chunkreflines);
                        if ($before_has_content or $first ne "\n") {
                            push(@res, $before . $first);
                        } else {
                            push(@res, "\n");
                        }
                        for (@chunkreflines) {
                            if (ref($_)) {
                                # deal with special items later
                                push(@res, $_);
                            } elsif ($_ ne "\n") {
                                push(@res, $indent . $_);
                            } else {
                                # no need to indent an empty line
                                push(@res, "\n");
                            }
                        }
                        if ($after) {
                            chomp($last);
                            $line_new = $indent . $last . $after . "\n";
                        } elsif ($last ne "\n") {
                            push(@res, $indent . $last);
                        } else {
                            # no need to indent an empty line
                            push(@res, "\n");
                        }
                    } else {
                        # case: just one line
                        if ($after) {
                            chomp(my $tmp = $chunkreflines[0]);
                            $line_new = $before . $tmp . $after . "\n";
                        } else {
                            my $before_has_content = $before !~ m{^\s*$};
                            if ($before_has_content or $chunkreflines[0] ne "\n") {
                                push(@res, $before . $chunkreflines[0]);
                            } else {
                                push(@res, "\n");
                            }
                        }
                    }
                    if (defined($line_new)) {
                        $line = $line_new;
                        next;
                    }
                } else {
                    $carp_or_croak->("WARNING: Code chunk <<${chunkref}>>" .
                        " does not exist (at ${fname}:${lnum}).");
                }
            } else {
                $line =~ s/\@(<<|>>)/$1/g;
                push(@res, $line);
            }
            last;
        }
    }
    $being_extracted{$chunk}--;
    return @res;
}
sub read_file {
    local @ARGV = @_;
    my $chunk = undef;
    while (my $line = <>) {
        chomp($line);
        if ($line =~ m{^ << (.+?) >>= \s* $}x) {
            $chunk = $1;
            if (!$chunks_options{$chunk}) {
                $chunks_options{$chunk} = {
                    nchunks => 0,
                    nextractions => 0,
                    first_fname => $ARGV,
                    first_lnum => int($.)
                };
            }
            $chunks_options{$chunk}->{nchunks}++;
        } elsif (defined($chunk)) {
            if ($line =~ m{^ \@ (?: $ | \s) }x) {
                $chunk = '';
            } else {
                # regular line inside chunk
                $line =~ s,^\@\@,\@,;
                set_many(%chunks, $chunk, $ARGV, int($.), $line . "\n");
            }
        }
    }
}
sub line_directive {
    my ($fname, $line) = @_;
    my $ret = $lineformat;
    $ret =~ s/%F/$fname/g;
    $ret =~ s/%L/$line/g;
    $ret =~ s/%N/\n/g;
    return $ret;
}
my @chunks = ();
my @files = ();
my $list_all = 0;
my $no_op = 0;
my $dump = 0;
my $load = 0;

while ($_ = shift(@ARGV)) {
    if (/^-L(.*)/) {
        $sync = 1;
        $lineformat = $1 if $1;
    }
    elsif (/^-R(.+)/)         { push(@chunks, $1) }
    elsif (/^-(v|-version)$/) { version(); exit(0) }
    elsif (/^--list-all$/)   { $list_all = 1 }
    elsif (/^--list-roots$/) { $list_roots = 1 }
    elsif (/^--no-op$/)      { $no_op = 1 }
    elsif (/^--dump=(.+)$/) { $dump = $1 }
    elsif (/^--dump$/)      { $dump = shift(@ARGV) }
    elsif (/^--load=(.+)$/) { $load = $1 }
    elsif (/^--load$/)      { $load = shift(@ARGV) }
    elsif (/^--error$/) { $carp_or_croak = \&Carp::croak; }
    elsif (/^-filter$/) { shift(@ARGV) }
    elsif (/^(-.+)$/) { usage($1); exit(1) }
    else { push(@files, $_) }
}

if ($dump eq '-') {
    if ($list_all or $list_roots or @chunks) {
        Carp::croak("ERROR: Cannot write to stdout due to output ambiguity.");
    }
    $no_op = 1;
}

if ($load) {
    require Storable;
    Storable->import(qw{lock_retrieve fd_retrieve});
    my $state;
    if ($load eq '-') {
        if (-t STDIN) {
            Carp::croak("ERROR: Will not load binary data from a terminal.");
        } else {
            $state = fd_retrieve(*STDIN);
        }
    } elsif (-f $load) {
        $state = lock_retrieve($load);
    } else {
        Carp::croak("ERROR: State file does not exist.");
    }
    %chunks_options = %{ $state->[0] };
    %chunks = %{ $state->[1] };
}

if ($load ne '-' and not @files) {
    push(@files, '-');
}
read_file($_) for @files;

if ($dump) {
    require Storable;
    Storable->import(qw{lock_store store_fd});
    my $state = [\%chunks_options, \%chunks];
    if ($dump eq '-') {
        if (-t STDOUT) {
            Carp::croak("ERROR: Will not dump binary data to a terminal.");
        } else {
            store_fd($state, \*STDOUT);
        }
    } else {
        lock_store($state, $dump);
    }
}

if ($no_op) {
    # useful for documentation chunks validation and set when dumping to
    # stdout
} elsif ($list_all) {
    print("<<${_}>>") for sort(keys(%chunks_options));
} elsif ($list_roots) {
    my @all_chunks = sort(keys(%chunks_options));
    # first pass, extract all chunks
    for my $chunk (@all_chunks) {
        my ($first_fname, $first_lnum) = get_many($chunks{$chunk});
        unless ($first_fname) {
            $first_fname = $chunks_options{$chunk}->{first_fname};
            $first_lnum = $chunks_options{$chunk}->{first_lnum};
        }
        extract('', $first_fname, $first_lnum, $chunk);
    }
    # second pass, report
    for my $chunk (@all_chunks) {
        my $opts = $chunks_options{$chunk};
        if ($opts->{nextractions} == 1) {
            print("<<${chunk}>>");
        }
    }
} else {
    if (not @chunks) {
        push(@chunks, '*');
    }
    for my $chunk (@chunks) {
        if (!$chunks_options{$chunk}) {
            Carp::croak("ERROR: The root chunk <<${chunk}>> was" .
                " not defined.");
        }
    }
    for my $chunk (@chunks) {
        @outputlines = ();
        my ($first_fname, $first_lnum) = get_many($chunks{$chunk});
        unless ($first_fname) {
            $first_fname = $chunks_options{$chunk}->{first_fname};
            $first_lnum = $chunks_options{$chunk}->{first_lnum};
        }
        for my $item (extract('', $first_fname, $first_lnum, $chunk)) {
            if (ref($item) eq 'ARRAY') {
                push(@outputlines, line_directive($_->[1], $_->[2]))
                    for @{ $item };
            } else {
                push(@outputlines, $item);
            }
        }
        {
            my ($n, $s, %names) = (q{?},);
            my %args = ();
            for ("#name ${chunk}", @outputlines) {
                chomp;
                if (m{^#name\s+(.*)\s*$}) {
                   $n = $1;
                   next;
                }
                next if m{^\s*#};
                # my $line = $_;
                s,\\\s*$,,;
                s,%,%25,g;
                s,\134\134,%5c%5c,g;
                s,\134\047,%27,g;
                s,\134\042,%22,g;
                s,\134,%5c,g;
                s{
                    (?:([^\047\042\s]*)\047) ( .*? ) (?:\047([^\047\042\s]*)) |
                    (?:([^\047\042\s]*)\042) ( .*? ) (?:\042([^\047\042\s]*)) |
                    ( [^\047\042\s]+ )
                }{
                    # print qq{"[1:$1][2:$2][3:$3][4:$4][5:$5][6:$6][7:$7][$line]};
                    if (defined($2)) {
                        $s = qq{${1}${2}${3}};
                    } elsif (defined($5)) {
                        my $s4 = $4;
                        my $s6 = $6;
                        ($s = $5) =~ s,%27|\047,\047\042\047\042\047,g;
                        $s = qq{${s4}${s}${s6}};
                    } elsif ($7) {
                        next if $7 eq q{%5c}; # only a line continuation
                        ($s = $7) =~ s,%5c$,,; # remove line continuation, if any
                    } else {
                        $s = q{exhaustion};
                    }
                    if ($s) {
                        $s = qq{\047} . unescape($s) . qq{\047};
                        $s =~ s,^\047\047|\047\047$,,g;
                        $s =~ s,;\047$,\047,g;
                    } else {
                        $s = qq{\047\047};
                    }
                    if ($s !~ m{^\047(?:set|--|\$\@)\047$}) {
                        $names{$n}++;
                $args{$n} = [] if $names{$n} == 1;
                push(@{$args{$n}}, $s);
                    }
                }gex;
            }
            for my $name (sort keys %args) {
                my @args = sort @{$args{$name}};
                print qq{<<set ${name}>>=};
                for my $arg (@args) {
                    print qq{set -- \042\$\@\042 $arg;};
                }
                print qq{<<push ${name}>>=};
                for my $arg (@args) {
                    $arg =~ s,^\047|\047$,,g;
                    print qq{push(\@\$listref, q{$arg});};
                }
            }
        }
    }
}
