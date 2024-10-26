
# automatically generated from Makefile.nw

SH = sh -eu

PRIORITY_TARGETS = \
    nofake-exec.sh

TARGETS = \
    create-config.sh show-config.sh new-item.sh make-index.sh find.sh \
    head-README.sh show-README.sh cat-README.sh detokenize--imports.nw detokenize.c \
    detokenize encrypt.sh decrypt.sh verify.sh git-last-modified.sh \
    localely-dist.nw nwsplit--imports.nw nwsplit.c nwsplit tokenize--imports.nw \
    tokenize.c tokenize

all: $(PRIORITY_TARGETS) $(TARGETS)

nofake-exec.sh: \
    nofake-exec.nw shell.nw temporary-files-shell.nw
	nofake --error -R'build nofake-exec.sh' $^ | $(SH)

create-config.sh: \
    create-config.nw shell.nw
	nofake --error -R'build create-config.sh' $^ | $(SH)

show-config.sh: \
    create-config.nw shell.nw
	nofake --error -R'build show-config.sh' $^ | $(SH)

new-item.sh: \
    create-config.nw new-item.nw shell.nw
	nofake --error -R'build new-item.sh' $^ | $(SH)

make-index.sh: \
    create-config.nw make-index.nw shell.nw
	nofake --error -R'build make-index.sh' $^ | $(SH)

find.sh: \
    create-config.nw find.nw shell.nw temporary-files-shell.nw
	nofake --error -R'build find.sh' $^ | $(SH)

head-README.sh: \
    create-config.nw head-README.nw shell.nw temporary-files-shell.nw
	nofake --error -R'build head-README.sh' $^ | $(SH)

show-README.sh: \
    create-config.nw shell.nw show-README.nw temporary-files-shell.nw
	nofake --error -R'build show-README.sh' $^ | $(SH)

cat-README.sh: \
    cat-README.nw create-config.nw shell.nw temporary-files-shell.nw
	nofake --error -R'build cat-README.sh' $^ | $(SH)

detokenize--imports.nw: \
    detokenize.nw repl.nw
	nofake --error -R'build detokenize--imports.nw' $^ | $(SH)

detokenize.c: \
    detokenize--imports.nw detokenize.nw strscan.nw
	nofake --error -R'build detokenize.c' $^ | $(SH)

detokenize: \
    detokenize--imports.nw detokenize.c detokenize.nw strscan.nw
	nofake --error -R'build detokenize' $^ | $(SH)

encrypt.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake --error -R'build encrypt.sh' $^ | $(SH)

decrypt.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake --error -R'build decrypt.sh' $^ | $(SH)

verify.sh: \
    encrypt.nw netstring-perl.nw shell.nw
	nofake --error -R'build verify.sh' $^ | $(SH)

git-last-modified.sh: \
    git-last-modified.nw shell.nw
	nofake --error -R'build git-last-modified.sh' $^ | $(SH)

localely-dist.nw: \
    localely.nw
	nofake --error -R'build localely-dist.nw' $^ | $(SH)

nwsplit--imports.nw: \
    nwsplit.nw repl.nw
	nofake --error -R'build nwsplit--imports.nw' $^ | $(SH)

nwsplit.c: \
    nwsplit--imports.nw nwsplit.nw strscan.nw
	nofake --error -R'build nwsplit.c' $^ | $(SH)

nwsplit: \
    nwsplit--imports.nw nwsplit.c nwsplit.nw strscan.nw
	nofake --error -R'build nwsplit' $^ | $(SH)

tokenize--imports.nw: \
    repl.nw tokenize.nw
	nofake --error -R'build tokenize--imports.nw' $^ | $(SH)

tokenize.c: \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.nw
	nofake --error -R'build tokenize.c' $^ | $(SH)

tokenize: \
    localely-dist.nw strscan.nw tokenize--imports.nw tokenize.c tokenize.nw
	nofake --error -R'build tokenize' $^ | $(SH)

clean:
	-rm -f $(TARGETS)
