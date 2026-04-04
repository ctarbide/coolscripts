#!/bin/sh
set -eu

are_we_good(){
check=$1; shift
perl -wsle'
open(my $fh, q{|-}, @ARGV) or die $!;
select((select($fh),$|++)[0]);
my $last;
while (<STDIN>) {
    chomp($last = $_);
    next if $last eq $check;
    print $fh $last;
}
exit 1 if $last ne $check;
' -- -check="${check}" "$@"
}

check="all good for $$"
(
    perl -wle'system(q{date +%N});select(undef,undef,undef,0.25)'
    perl -wle'system(q{date +%N});select(undef,undef,undef,0.25)'
    perl -wle'system(q{date +%N});select(undef,undef,undef,0.25)'
    test "x${1:-}" = xyes
    echo all good so far
    echo "${check}"
) | are_we_good "${check}" tee are_we_good.log

echo absolutely good
