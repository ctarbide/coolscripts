
# automatically generated from Makefile.nw

SH = sh -eu

PRIORITY_TARGETS = \
    nofake-exec.sh

TARGETS = \
    cat-README.sh create-config.sh cstrng.sh decrypt.sh detokenize \
    detokenize--imports.nw detokenize.c encrypt.sh feh-smart-latest.sh find-strict.sh \
    find.sh git-last-modified.sh head-README.sh localely-dist.nw make-index.sh \
    new-item.sh nwsplit nwsplit--imports.nw nwsplit.c seed.sh \
    show-README.sh show-config.sh shuffle-noseq.sh shuffle.sh stretch.sh \
    test-shuffle-noseq.sh tokenize tokenize--imports.nw tokenize.c unshuffle.sh \
    verify.sh

ALL_TARGETS = $(PRIORITY_TARGETS) $(TARGETS)

.PHONY: all
all: $(ALL_TARGETS)

nofake-exec.sh: \
    listings.nw nofake-exec.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build nofake-exec.sh' $^ -- $(SH)

cat-README.sh: \
    listings.nw cat-README.nw create-config.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build cat-README.sh' $^ -- $(SH)

create-config.sh: \
    listings.nw create-config.nw shell.nw
	nofake-exec.sh --error -R'build create-config.sh' $^ -- $(SH)

cstrng.sh: \
    listings.nw cstrng.nw
	nofake-exec.sh --error -R'build cstrng.sh' $^ -- $(SH)

decrypt.sh: \
    listings.nw encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build decrypt.sh' $^ -- $(SH)

detokenize: \
    listings.nw detokenize--imports.nw detokenize.c detokenize.nw strscan.nw
	nofake-exec.sh --error -R'build detokenize' $^ -- $(SH)

detokenize--imports.nw: \
    listings.nw detokenize.nw repl.nw
	nofake-exec.sh --error -R'build detokenize--imports.nw' $^ -- $(SH)

detokenize.c: \
    listings.nw detokenize--imports.nw detokenize.nw strscan.nw
	nofake-exec.sh --error -R'build detokenize.c' $^ -- $(SH)

encrypt.sh: \
    listings.nw encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build encrypt.sh' $^ -- $(SH)

feh-smart-latest.sh: \
    listings.nw feh-smart-latest.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build feh-smart-latest.sh' $^ -- $(SH)

find-strict.sh: \
    listings.nw create-config.nw find-strict.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build find-strict.sh' $^ -- $(SH)

find.sh: \
    listings.nw create-config.nw find.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build find.sh' $^ -- $(SH)

git-last-modified.sh: \
    listings.nw git-last-modified.nw shell.nw
	nofake-exec.sh --error -R'build git-last-modified.sh' $^ -- $(SH)

head-README.sh: \
    listings.nw create-config.nw head-README.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build head-README.sh' $^ -- $(SH)

localely-dist.nw: \
    listings.nw localely.nw
	nofake-exec.sh --error -R'build localely-dist.nw' $^ -- $(SH)

make-index.sh: \
    listings.nw create-config.nw make-index.nw shell.nw
	nofake-exec.sh --error -R'build make-index.sh' $^ -- $(SH)

new-item.sh: \
    listings.nw create-config.nw new-item.nw shell.nw
	nofake-exec.sh --error -R'build new-item.sh' $^ -- $(SH)

nwsplit: \
    listings.nw nwsplit--imports.nw nwsplit.c nwsplit.nw strscan.nw
	nofake-exec.sh --error -R'build nwsplit' $^ -- $(SH)

nwsplit--imports.nw: \
    listings.nw nwsplit.nw repl.nw
	nofake-exec.sh --error -R'build nwsplit--imports.nw' $^ -- $(SH)

nwsplit.c: \
    listings.nw nwsplit--imports.nw nwsplit.nw strscan.nw
	nofake-exec.sh --error -R'build nwsplit.c' $^ -- $(SH)

seed.sh: \
    listings.nw cstrng.nw
	nofake-exec.sh --error -R'build seed.sh' $^ -- $(SH)

show-README.sh: \
    listings.nw create-config.nw shell.nw show-README.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build show-README.sh' $^ -- $(SH)

show-config.sh: \
    listings.nw create-config.nw shell.nw
	nofake-exec.sh --error -R'build show-config.sh' $^ -- $(SH)

shuffle-noseq.sh: \
    listings.nw shell.nw shuffle.nw
	nofake-exec.sh --error -R'build shuffle-noseq.sh' $^ -- $(SH)

shuffle.sh: \
    listings.nw shell.nw shuffle.nw
	nofake-exec.sh --error -R'build shuffle.sh' $^ -- $(SH)

stretch.sh: \
    listings.nw shell.nw stretch.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build stretch.sh' $^ -- $(SH)

test-shuffle-noseq.sh: \
    listings.nw shell.nw shuffle.nw
	nofake-exec.sh --error -R'build test-shuffle-noseq.sh' $^ -- $(SH)

tokenize: \
    listings.nw localely-dist.nw strscan.nw tokenize--imports.nw tokenize.c \
    tokenize.nw
	nofake-exec.sh --error -R'build tokenize' $^ -- $(SH)

tokenize--imports.nw: \
    listings.nw repl.nw tokenize.nw
	nofake-exec.sh --error -R'build tokenize--imports.nw' $^ -- $(SH)

tokenize.c: \
    listings.nw localely-dist.nw strscan.nw tokenize--imports.nw tokenize.nw
	nofake-exec.sh --error -R'build tokenize.c' $^ -- $(SH)

unshuffle.sh: \
    listings.nw shell.nw temporary-files-shell.nw unshuffle.nw
	nofake-exec.sh --error -R'build unshuffle.sh' $^ -- $(SH)

verify.sh: \
    listings.nw encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build verify.sh' $^ -- $(SH)

.PHONY: touch
touch:
	-touch -c $(ALL_TARGETS)

.PHONY: clean
clean:
	-rm -f $(TARGETS)
