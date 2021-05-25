#!/usr/bin/env perl
#
# (sleep 1; echo -e 'hi\nthere'; sleep 2) | ./chargen.pl
#
# reference: http://www.perlmonks.org/?node_id=1952
#

eval 'exec perl -wS $0 ${1+"$@"}'
    if 0;

use strict;
use warnings;

use Fcntl qw(F_GETFL F_SETFL O_NONBLOCK);

my $delay = (shift || 0.25);
$delay >= 0.025 or die "delay $delay must be >= 0.025";

$| = 1;

my @a = (33..126, 33..126);
my $b = join("", map(chr, @a));

my $STDIN_fileno = fileno(STDIN);

my $rin = '';
vec($rin, $STDIN_fileno, 1) = 1;

set_nonblock(\*STDIN);

for (my $i=0; ; $i=($i+1)%94) {
    print substr($b, $i, 72), "\n";
    if (select(my $rout=$rin, undef, undef, $delay)) {
	local $/= undef;  # clear the input record separator to
			  # suppress line buffering
	if (vec($rout, $STDIN_fileno, 1) == 1) {
	    if (defined(my $what = <STDIN>)) {  # perldoc -f '<>'
		print "chargen.pl: STDIN=[$what]\n";
	    } else {
		print "chargen.pl: get EOF on STDIN, over and out\n";
		last;
	    }
	} else {
	    die "exhaustion";
	}
    }
}

exit 0;

sub set_nonblock
{
    my $fh = shift;
    my $flags = fcntl($fh, F_GETFL, 0) or die;
    $flags = fcntl($fh, F_SETFL, $flags | O_NONBLOCK) or die;
}
