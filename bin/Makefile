
# automatically generated from Makefile.nw

SH = sh -eu

SOURCES = \
    Makefile.nw create-config.nw cstrng.nw detokenize.nw encrypt.nw \
    feh-smart-latest.nw git-last-modified.nw localely.nw nwsplit.nw repl.nw \
    shuffle.nw stretch.nw tokenize.nw unshuffle.nw

TARGETS = listings.nw \
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

cat-README.sh: listings.nw \
    cat-README.nw create-config.nw shell.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'cat-README.sh' Makefile.nw listings.nw -- $(SH)

create-config.sh: listings.nw \
    create-config.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'create-config.sh' Makefile.nw listings.nw -- $(SH)

cstrng.sh: listings.nw \
    cstrng.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'cstrng.sh' Makefile.nw listings.nw -- $(SH)

decrypt.sh: listings.nw \
    encrypt.nw netstring-perl.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'decrypt.sh' Makefile.nw listings.nw -- $(SH)

detokenize: listings.nw \
    detokenize--imports.nw detokenize.c detokenize.nw strscan.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'detokenize' Makefile.nw listings.nw -- $(SH)

detokenize--imports.nw: listings.nw \
    detokenize.nw repl.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'detokenize--imports.nw' Makefile.nw listings.nw -- $(SH)

detokenize.c: listings.nw \
    detokenize--imports.nw detokenize.nw strscan.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'detokenize.c' Makefile.nw listings.nw -- $(SH)

encrypt.sh: listings.nw \
    encrypt.nw netstring-perl.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'encrypt.sh' Makefile.nw listings.nw -- $(SH)

feh-smart-latest.sh: listings.nw \
    feh-smart-latest.nw shell.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'feh-smart-latest.sh' Makefile.nw listings.nw -- $(SH)

find-strict.sh: listings.nw \
    create-config.nw find-strict.nw shell.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'find-strict.sh' Makefile.nw listings.nw -- $(SH)

find.sh: listings.nw \
    create-config.nw find.nw shell.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'find.sh' Makefile.nw listings.nw -- $(SH)

git-last-modified.sh: listings.nw \
    git-last-modified.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'git-last-modified.sh' Makefile.nw listings.nw -- $(SH)

head-README.sh: listings.nw \
    create-config.nw head-README.nw shell.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'head-README.sh' Makefile.nw listings.nw -- $(SH)

localely-dist.nw: listings.nw \
    localely.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'localely-dist.nw' Makefile.nw listings.nw -- $(SH)

make-index.sh: listings.nw \
    create-config.nw make-index.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'make-index.sh' Makefile.nw listings.nw -- $(SH)

new-item.sh: listings.nw \
    create-config.nw new-item.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'new-item.sh' Makefile.nw listings.nw -- $(SH)

nwsplit: listings.nw \
    nwsplit--imports.nw nwsplit.c nwsplit.nw strscan.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'nwsplit' Makefile.nw listings.nw -- $(SH)

nwsplit--imports.nw: listings.nw \
    nwsplit.nw repl.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'nwsplit--imports.nw' Makefile.nw listings.nw -- $(SH)

nwsplit.c: listings.nw \
    nwsplit--imports.nw nwsplit.nw strscan.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'nwsplit.c' Makefile.nw listings.nw -- $(SH)

seed.sh: listings.nw \
    cstrng.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'seed.sh' Makefile.nw listings.nw -- $(SH)

show-README.sh: listings.nw \
    create-config.nw shell.nw show-README.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'show-README.sh' Makefile.nw listings.nw -- $(SH)

show-config.sh: listings.nw \
    create-config.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'show-config.sh' Makefile.nw listings.nw -- $(SH)

shuffle-noseq.sh: listings.nw \
    shell.nw shuffle.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'shuffle-noseq.sh' Makefile.nw listings.nw -- $(SH)

shuffle.sh: listings.nw \
    shell.nw shuffle.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'shuffle.sh' Makefile.nw listings.nw -- $(SH)

stretch.sh: listings.nw \
    shell.nw stretch.nw temporary-files-shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'stretch.sh' Makefile.nw listings.nw -- $(SH)

test-shuffle-noseq.sh: listings.nw \
    shell.nw shuffle.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'test-shuffle-noseq.sh' Makefile.nw listings.nw -- $(SH)

tokenize: listings.nw \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.c tokenize.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'tokenize' Makefile.nw listings.nw -- $(SH)

tokenize--imports.nw: listings.nw \
    repl.nw tokenize.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'tokenize--imports.nw' Makefile.nw listings.nw -- $(SH)

tokenize.c: listings.nw \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'tokenize.c' Makefile.nw listings.nw -- $(SH)

unshuffle.sh: listings.nw \
    shell.nw temporary-files-shell.nw unshuffle.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'unshuffle.sh' Makefile.nw listings.nw -- $(SH)

verify.sh: listings.nw \
    encrypt.nw netstring-perl.nw shell.nw
	@SH='$(SH)' nofake-exec.sh --error -R'run recipe' --aa-- 'verify.sh' Makefile.nw listings.nw -- $(SH)

.PHONY: touch
touch:
	-touch -c $(TARGETS)

.PHONY: clean
clean:
	-rm -f $(TARGETS)
