
**************** getting started

nofake README--ftp.cs.utexas.edu.txt

**************** configuration

<<this README file name>>=
README--ftp.cs.utexas.edu.txt
@

<<site identification>>=
ftp.cs.utexas.edu--pub--boyer--nqthm
@

<<ftp prefix>>=
ftp.cs.utexas.edu/pub/boyer/nqthm
@

<<*>>=
nofake '<<this README file name>>' -Rbootstrap | sh

nofake '<<this README file name>>' -Rlist-dot-listing-paths-dirs_only | perl -- - | tee '<<site identification>>.dirs'

nofake '<<this README file name>>' -Rlist-pending-dirs-sh | sh | download-full-dirs.sh | sh

nofake '<<this README file name>>' -Rlist-pending-urls | sh | download-full-dirs.sh | sh
@

**************** bootstraping

<<bootstrap>>=
test -f '<<ftp prefix>>/.listing' || echo 'ftp://<<ftp prefix>>/' | download-full-dirs.sh | sh
@

**************** shell code snippets

<<list-pending-dirs-sh>>=
cat '<<site identification>>.dirs' |
    perl -lne'next unless m{^ftp://(.*)$}i; next if -f qq{${1}.listing}; print(qq{ftp://${1}})'
@

'listings' is not needed due to '.listing' ftp files downloaded by wget

<<list-pending-listings-sh>>=
safe-bak.sh listings
cp -f listings .tmp.listings
nofake -Rlist-pending-listings '<<this README file name>>' | perl -- - .tmp.listings '<<site identification>>.dirs'
@

<<list-pending-urls>>=
nofake -Rlist-dot-listing-paths-files_only '<<this README file name>>' | perl -- - | filter-out-existing-urls.sh
@

**************** perl code snippets

<<perl common header>>=
use 5.008;
use strict;
use warnings FATAL => 'uninitialized';
$\ = "\n";
@

<<autoflush on and buffering off>>=
local $| = 1; # 1=autoflush on (turn off buffering)
@

<<use File::Find>>=
use File::Find ();
@

<<list-pending-listings>>=
<<perl common header>>
my $listings = shift(@ARGV);
my @ftp_dirs = @ARGV;
my %inputs;
{ @ARGV = $listings; while(<>){ chomp;
    $inputs{$1}++ if m{^input args: (.*)};
}}
{ @ARGV = @ftp_dirs; while(<>){ chomp;
    next unless m{^(.*)$}i;
    my $url = qq{ftp://${1}};
    print qq{${url}} unless $inputs{$url};
}}
@

This sub requires use of File::Find module.

<<sub get_dot_listing_files>>=
sub get_dot_listing_files {
    my $dir = shift;
    my @files;
    File::Find::find({
        wanted => sub {
            return if -d $_;
            push(@files, $_) if $_ =~ m{/\.listing$};
        },
        follow => 1,
        no_chdir => 1,
    }, $dir);
    return sort(@files);
}
@

<<list-dot-listing-dirs>>=
<<perl common header>>
<<use File::Find>>
<<sub get_dot_listing_files>>
my @files = get_dot_listing_files("<<ftp prefix>>");
for (@files) {
    my ($dir) = m{^(.*)/\.listing$};
    print("${dir}");
}
@

<<list-dot-listing-paths-dirs_only>>=
<<perl common header>>
<<use File::Find>>
<<sub get_dot_listing_files>>
my @files = get_dot_listing_files("<<ftp prefix>>");
{ @ARGV = @files; while(<>){ chomp;
    my ($dir) = ($ARGV =~ m{^(.*)/\.listing$});
    my @F = split;
    next if $F[8] eq '.' or $F[8] eq '..';
    next unless $F[0] =~ m{^d};
    print("ftp://${dir}/$F[8]/");
}}
@

<<list-dot-listing-paths-files_only>>=
<<perl common header>>
<<use File::Find>>
<<sub get_dot_listing_files>>
my @files = get_dot_listing_files("<<ftp prefix>>");
{ @ARGV = @files; while(<>){ chomp;
    my ($dir) = ($ARGV =~ m{^(.*)/\.listing$});
    my @F = split;
    next if $F[8] eq '.' or $F[8] eq '..';
    next if $F[0] =~ m{^d};
    print("ftp://${dir}/$F[8]");
}}
@

****************
