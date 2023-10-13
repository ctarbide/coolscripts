#!/bin/sh
set -eu
thispath=`perl -MCwd=realpath -le'print(realpath(\$ARGV[0]))' -- "${0}"`
thisdir=${thispath%/*}
exec perl -MIPC::Open2 -MDigest::SHA=sha256 -se'
    sub ns ($) { length($_[0]) . qq{:} . $_[0] . q{,} }
    sub nsget ($) {
        return unless defined wantarray;
        $_[0] =~ m{^(\d+):} or die qq{Error, invalid netstring.};
        my $skip = length($1) + $1 + 2;
        my $data = substr($_[0], length($1) + 1, $1);
        return wantarray ? ($skip, $data) : $data;
    }
    sub nssplit ($) {
        my $ofs = 0;
        my $len = length($_[0]);
        my @res;
        while ($ofs < $len) {
            ($next, $data) = nsget(substr($_[0], $ofs));
            push(@res, $data);
            $ofs += $next;
        }
        @res;
    }
    sub nskvpair (@) {
        my ($next, $key, %res);
        for my $kvp (@_) {
            ($next, $key) = nsget($kvp);
            $res{$key} = nsget(substr($kvp, $next));
        }
        %res;
    }
    sub nsstart0 ($;$) {
        my $read = $_[0];
        my $fh = $_[1];
        my $res;
        my $len;
        if ($read->($fh, my $c, 2)) {
            die "Error, invalid netstring." unless $c =~ m{^\d[\d:]$};
            $len = int($c);
        } else {
            die "Error, no data.";
        }
        while($read->($fh, my $c, 1)){
            last if $c eq q{:};
            die "Error, invalid netstring." unless $c =~ m{^\d$};
            $len = $len * 10 + $c;
        }
        $read->($fh, $res, $len) == $len or die "Error, missing data.";
        $read->($fh, my $comma, 1) or die "Error, missing comma.";
        $comma eq q{,} or die "Error, no comma.";
        $res;
    }
    sub nsstart ($) {
        nsstart0(sub{read($_[0], $_[1], $_[2], $_[3])}, $_[0]);
    }
    sub mac ($$) { sha256(sha256(ns($_[0]) . $_[1])) }
    sub tag ($$$) { substr(sha256(sha256(ns($_[0]) . ns($_[1]) . $_[2])), 0, 16) }
    sub csprng_session ($$$$) {
        my ($master_key, $sub_key, $nonce, $len) = @_;
        die unless defined($master_key) and defined($sub_key) and defined($nonce) and defined($len);
        open2(my $chld_out, my $chld_in, q{csprng.sh});
        print $chld_in ns($master_key);
        print $chld_in ns($sub_key);
        print $chld_in ns($nonce);
        close $chld_in;
        read($chld_out, my $res, $len) == $len or die;
        close $chld_out;
        $res;
    }
    sub csprng_stream ($$$) {
        my ($master_key, $sub_key, $nonce) = @_;
        die unless defined($master_key) and defined($sub_key) and defined($nonce);
        open2(my $chld_out, my $chld_in, q{csprng.sh});
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

    die unless @ARGV == 1;
    open(E, q{<}, $ARGV[0]) or die qq{Error, can\047t open } . $ARGV[0] . qq{: $!};
    read(E, my $nonce, 32) == 32 or die;

    my $mac_key = csprng_session($master_key, $sub_mac_key, $nonce, 32);
    my $tag_key = csprng_session($master_key, $sub_tag_key, $nonce, 32);
    my $mkspipe = csprng_stream($master_key, $sub_meta_keystream, $nonce);
    my $ckspipe = csprng_stream($master_key, $sub_cipher_keystream, $nonce);

    sub readmeta ($$) {
        my ($fh, $len) = @_;
        read($fh, my $e, $len) == $len or die;
        ($e, cipher($mkspipe, $e))
    }

    my $metainf = q{};

    sub readmetawrapper {
        (my $e, $_[1]) = readmeta(E, $_[2]);
        $metainf .= $e;
        $_[2];
    }

    my $header = nsstart0(\&readmetawrapper);

    read(E, my $mac_header, 32) == 32 or die;
    die "Error, invalid MAC." unless $mac_header eq mac($mac_key, $metainf);

    my @header = nssplit($header);
    my %header = nskvpair(@header);

    die "Error, unexpected version: \"$header{version}\"." unless $header{version} eq q{1.0};

    my $ofs = 0;

    while (1) {
        readmetawrapper(undef, my $packedlen, 2);
        my $len = unpack(q{n}, $packedlen);
        last if $len == 0;
        read(E, my $tag, 16) == 16 or die;
        $metainf .= $tag;
        read(E, my $e, $len) == $len or die;
        die "Error, invalid TAG." unless $tag eq tag($tag_key, $ofs, $e);
        print(cipher($ckspipe, $e));
        $ofs += $len;
    }

    read(E, my $mac_all, 32) == 32 or die;
    die "Error, invalid MAC." unless $mac_all eq mac($mac_key, $metainf);
' -- -thisdir="${thisdir}" "$@"
