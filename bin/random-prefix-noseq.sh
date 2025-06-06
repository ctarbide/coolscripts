#!/bin/sh
set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

key=

while [ $# -gt 0 ]; do
    case "${1}" in
        -k|--key) key=${2}; shift ;;
        --key=*) key=${1#*=} ;;
        -k*) key=${1#??} ;;

        --) ;; # no-op
        *)
            die 1 "${0##*/}: Unrecognized option '${1}'." 1>&2
            ;;
    esac
    shift
done

if [ x"${key}" = x- ]; then
    die 1 "Error, standard input is reserved for lines that will be prefixed." 1>&2
fi

if [ x"${key}" = x ]; then
    die 1 "Error, missing key." 1>&2
fi

if [ ! -r "${key}" ]; then
    die 1 "Error, key does not exist or cannot be read." 1>&2
fi

exec perl -MIPC::Open2 -e'
$c0 = 0;
$c1 = 0;

sub seq {
    $c0 = ($c0 + 1) & 0xffffffff;
    $c1 = ($c1 + 1) & 0xffffffff unless $c0;
    sprintf(q{%08x%08x}, $c1, $c0);
}

sub csprng_stream ($) {
    open2(my $chld_out, my $chld_in, q{csprng.sh});
    print $chld_in $_[0];
    close $chld_in;
    $chld_out;
}

my $rngstream = csprng_stream(do {local (*ARGV, $/) = ([$ARGV[0]]); <>});

my @rngseq;

sub refill () {
    read($rngstream, my $d, 4*1024);
    @rngseq = unpack(q{N*}, $d);
}

sub get2 () {
    refill unless @rngseq;
    splice(@rngseq, 0, 2);
}

@ARGV = qw{-};
while (<>){
    chomp;
    my ($a, $b) = get2;
    printf(qq{%08x%08x\t%s\n}, $a, $b, $_);
}' -- "${key}"
