#!/bin/sh
exec perl -MScalar::Util=looks_like_number -e'
sub bitops ($$$) {
    my ($bits, $x, $y) = @_;
    my $len = length($x);
    die q{Error, operators must be of the same length.} unless $len == length($y);
    my $clear = $bits ^ 0xff;
    my $clearpack = unpack(q{Q}, chr($clear) x 8);
    my $ofs = 0;
    my $res = q{};
    my (@a, @b, $a, $b);
    @a = unpack(q{Q*}, $x);
    @b = unpack(q{Q*}, $y);
    my $i = 0;
    for $a (@a) {
        $res .= pack(q{Q}, ($clearpack & $a) ^ $b[$i++]);
    }
    $ofs = $len & ~7;
    while ($ofs < $len) {
        $a = ord(substr($x, $ofs, 1));
        $b = ord(substr($y, $ofs, 1));
        $res .= chr(($clear & $a) ^ $b);
        $ofs++;
    }
    $res;
}
my $clear;
if (@ARGV >= 1) {
    die qq{Error, $ARGV[0] is not a number.} unless looks_like_number($ARGV[0]);
    $clear = eval($ARGV[0]);
}
my $argscheck = join(@ARGV, @ARGV[1..$#ARGV]);
if (@ARGV == 1 or $argscheck =~ m{^( - | - 3 - )$}x) {
    while (read(STDIN, my $a, 4096)) {
        print(bitops($clear, $a, $a));
    }
} elsif (@ARGV == 2) {
    open(DATA, q{<}, $ARGV[1]);
    while (read(STDIN, my $a, 4096)) {
        read(DATA, my $b, length($a)) or die;
        print(bitops($clear, $a, $b));
    }
    close(DATA);
} elsif (@ARGV == 3) {
    my $open_A = $ARGV[1] ne q{-};
    my $open_B = $ARGV[2] ne q{-};
    open(A, q{<}, $ARGV[1]) or die qq{$!: "$ARGV[1]"} if $open_A;
    open(B, q{<}, $ARGV[2]) or die qq{$!: "$ARGV[2]"} if $open_B;
    *A = *STDIN unless $open_A;
    *B = *STDIN unless $open_B;
    while (read(A, my $a, 4096)) {
        read(B, my $b, length($a)) or die;
        print(bitops($clear, $a, $b));
    }
    close(A) if $open_A;
    close(B) if $open_B;
} else {
    die q{Error, invalid usage.};
}' -- "$@"
