#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
exec perl -MIPC::Open2 -MDigest::SHA=sha256 -se'
    sub ns ($) { length($_[0]) . qq{:} . $_[0] . q{,} }
    sub mac ($$) { sha256(sha256(ns($_[0]) . $_[1])) }
    sub tag ($$$) { substr(sha256(sha256(ns($_[0]) . ns($_[1]) . $_[2])), 0, 16) }
    sub csprng_session_kdf ($$$$) {
        my ($master_key, $sub_key, $nonce, $len) = @_;
        die unless defined($master_key) and defined($sub_key) and defined($nonce) and defined($len);
        open2(my $chld_out, my $chld_in, qq{${thisdir}/csprng.sh});
        print $chld_in ns($master_key);
        print $chld_in ns($sub_key);
        print $chld_in ns($nonce);
        close $chld_in;
        read($chld_out, my $res, $len) == $len or die;
        close $chld_out;
        $res;
    }
    sub csprng_session_stream ($$$) {
        my ($master_key, $sub_key, $nonce) = @_;
        die unless defined($master_key) and defined($sub_key) and defined($nonce);
        open2(my $chld_out, my $chld_in, qq{${thisdir}/csprng.sh});
        print $chld_in ns($master_key);
        print $chld_in ns($sub_key);
        print $chld_in ns($nonce);
        close $chld_in;
        $chld_out;
    }
    sub xor_ ($$) {
        my ($x, $y) = @_;
        my $len = length($x);
        die q{Error, operators must be of the same length.} unless $len == length($y);
        my (@a, @b, $a, $b);
        @a = unpack(q{Q*}, $x);
        @b = unpack(q{Q*}, $y);
        my ($res, $i) = (q{}, 0);
        for $a (@a) {
            $res .= pack(q{Q}, $a ^ $b[$i++]);
        }
        my $ofs = $len & ~7;
        while ($ofs < $len) {
            $a = ord(substr($x, $ofs, 1));
            $b = ord(substr($y, $ofs, 1));
            $res .= chr($a ^ $b);
            $ofs++;
        }
        $res;
    }
    sub cipher ($$) {
        my $len = length($_[1]);
        read($_[0], my $ks, $len) == $len or die;
        xor_($_[1], $ks);
    }

    my ($master_key, $sub_mac_key, $sub_tag_key, $sub_meta_keystream, $sub_cipher_keystream);
    {
        my $secret = `"${thisdir}/csprng.sh" | "${thisdir}/ddfb.sh" bs=32 count=5`;
        die unless length($secret) == 32 * 5;
        sub subkey ($) { substr($secret, $_[0] * 32, 32) }
        $master_key = subkey(0);
        $sub_mac_key = subkey(1);
        $sub_tag_key = subkey(2);
        $sub_meta_keystream = subkey(3);
        $sub_cipher_keystream = subkey(4);
    }

    my $nonce = `"${thisdir}/cstrng.sh" | "${thisdir}/ddfb.sh" bs=32 count=1`;
    die unless length($nonce) == 32;

    my $mac_key = csprng_session_kdf($master_key, $sub_mac_key, $nonce, 32);
    my $tag_key = csprng_session_kdf($master_key, $sub_tag_key, $nonce, 32);
    my $mkspipe = csprng_session_stream($master_key, $sub_meta_keystream, $nonce);
    my $ckspipe = csprng_session_stream($master_key, $sub_cipher_keystream, $nonce);

    sub printmeta ($) {
        my $res = cipher($mkspipe, $_[0]);
        print($res);
        $res;
    }

    print $nonce;

    my $header = q{};
    $header .= ns(ns(q{version}) . ns(q{1.0}));

    my $metainf = printmeta(ns($header));

    print(mac($mac_key, $metainf));

    my $ofs = 0;

    for my $fname (@ARGV) {
        open(my $fh, q{<}, $fname) or die qq{Error, can\047t open ${fname}: $!};
        while(read($fh, my $plain, 1<<15)){
            my $len = length($plain);
            my $e = cipher($ckspipe, $plain);
            my $tag = tag($tag_key, $ofs, $e);
            $metainf .= printmeta(pack(q{n}, $len)) . $tag;
            print($tag);
            print($e);
            $ofs += $len;
        }
        close($fh);
    }

    $metainf .= printmeta(pack(q{n}, 0));  # eof
    print(mac($mac_key, $metainf));
' -- -thisdir="${thisdir}" "$@"
