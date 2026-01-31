
# automatically generated from Makefile.nw

SH = sh -eu

SOURCES = \
    Makefile.nw create-config.nw cstrng.nw detokenize.nw encrypt.nw \
    feh-smart-latest.nw git-last-modified.nw localely.nw nwsplit.nw repl.nw \
    shuffle.nw stretch.nw tokenize.nw unshuffle.nw

TARGETS = \
    cat-README.sh create-config.sh cstrng.sh decrypt.sh detokenize \
    detokenize--imports.nw detokenize.c encrypt.sh feh-smart-latest.sh find-strict.sh \
    find.sh git-last-modified.sh head-README.sh localely-dist.nw make-index.sh \
    new-item.sh nwsplit nwsplit--imports.nw nwsplit.c seed.sh \
    show-README.sh show-config.sh shuffle-noseq.sh shuffle.sh stretch.sh \
    test-shuffle-noseq.sh tokenize tokenize--imports.nw tokenize.c unshuffle.sh \
    verify.sh

.PHONY: all
all: $(TARGETS)

listings.nw: $(SOURCES)
	rm -f listings.nw
	nofake-exec.sh --error -R'generate listings.nw' $^ -- $(SH) >listings.nw
	chmod 0444 listings.nw

cat-README.sh: \
    cat-README.nw create-config.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build cat-README.sh' $^ -- $(SH)

create-config.sh: \
    create-config.nw shell.nw
	nofake-exec.sh --error -R'build create-config.sh' $^ -- $(SH)

cstrng.sh: \
    cstrng.nw
	nofake-exec.sh --error -R'build cstrng.sh' $^ -- $(SH)

decrypt.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build decrypt.sh' $^ -- $(SH)

detokenize: \
    detokenize--imports.nw detokenize.c detokenize.nw strscan.nw
	nofake-exec.sh --error -R'build detokenize' $^ -- $(SH)

detokenize--imports.nw: \
    detokenize.nw repl.nw
	nofake-exec.sh --error -R'build detokenize--imports.nw' $^ -- $(SH)

detokenize.c: \
    detokenize--imports.nw detokenize.nw strscan.nw
	nofake-exec.sh --error -R'build detokenize.c' $^ -- $(SH)

encrypt.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build encrypt.sh' $^ -- $(SH)

feh-smart-latest.sh: \
    feh-smart-latest.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build feh-smart-latest.sh' $^ -- $(SH)

find-strict.sh: \
    create-config.nw find-strict.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build find-strict.sh' $^ -- $(SH)

find.sh: \
    create-config.nw find.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build find.sh' $^ -- $(SH)

git-last-modified.sh: \
    git-last-modified.nw shell.nw
	nofake-exec.sh --error -R'build git-last-modified.sh' $^ -- $(SH)

head-README.sh: \
    create-config.nw head-README.nw shell.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build head-README.sh' $^ -- $(SH)

localely-dist.nw: \
    localely.nw
	nofake-exec.sh --error -R'build localely-dist.nw' $^ -- $(SH)

make-index.sh: \
    create-config.nw make-index.nw shell.nw
	nofake-exec.sh --error -R'build make-index.sh' $^ -- $(SH)

new-item.sh: \
    create-config.nw new-item.nw shell.nw
	nofake-exec.sh --error -R'build new-item.sh' $^ -- $(SH)

nwsplit: \
    nwsplit--imports.nw nwsplit.c nwsplit.nw strscan.nw
	nofake-exec.sh --error -R'build nwsplit' $^ -- $(SH)

nwsplit--imports.nw: \
    nwsplit.nw repl.nw
	nofake-exec.sh --error -R'build nwsplit--imports.nw' $^ -- $(SH)

nwsplit.c: \
    nwsplit--imports.nw nwsplit.nw strscan.nw
	nofake-exec.sh --error -R'build nwsplit.c' $^ -- $(SH)

seed.sh: \
    cstrng.nw
	nofake-exec.sh --error -R'build seed.sh' $^ -- $(SH)

show-README.sh: \
    create-config.nw shell.nw show-README.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build show-README.sh' $^ -- $(SH)

show-config.sh: \
    create-config.nw shell.nw
	nofake-exec.sh --error -R'build show-config.sh' $^ -- $(SH)

shuffle-noseq.sh: \
    shell.nw shuffle.nw
	nofake-exec.sh --error -R'build shuffle-noseq.sh' $^ -- $(SH)

shuffle.sh: \
    shell.nw shuffle.nw
	nofake-exec.sh --error -R'build shuffle.sh' $^ -- $(SH)

stretch.sh: \
    shell.nw stretch.nw temporary-files-shell.nw
	nofake-exec.sh --error -R'build stretch.sh' $^ -- $(SH)

test-shuffle-noseq.sh: \
    shell.nw shuffle.nw
	nofake-exec.sh --error -R'build test-shuffle-noseq.sh' $^ -- $(SH)

tokenize: \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.c tokenize.nw
	nofake-exec.sh --error -R'build tokenize' $^ -- $(SH)

tokenize--imports.nw: \
    repl.nw tokenize.nw
	nofake-exec.sh --error -R'build tokenize--imports.nw' $^ -- $(SH)

tokenize.c: \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.nw
	nofake-exec.sh --error -R'build tokenize.c' $^ -- $(SH)

unshuffle.sh: \
    shell.nw temporary-files-shell.nw unshuffle.nw
	nofake-exec.sh --error -R'build unshuffle.sh' $^ -- $(SH)

verify.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake-exec.sh --error -R'build verify.sh' $^ -- $(SH)

.PHONY: touch
touch:
	-touch -c $(TARGETS)

.PHONY: clean
clean:
	-rm -f $(TARGETS)
