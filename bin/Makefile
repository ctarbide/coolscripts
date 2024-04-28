
# automatically generated from Makefile.nw

SH = sh -eu

SOURCES = \
    Makefile.nw create-config.nw detokenize.nw git-last-modified.nw nofake-exec.nw \
    nwsplit.nw parse.nw repl.nw tokenize.nw

TARGETS = \
    create-config.sh show-config.sh new-item.sh make-index.sh find.sh \
    head-README.sh show-README.sh cat-README.sh detokenize.c detokenize \
    git-last-modified.sh nofake-exec.sh nwsplit.c nwsplit parse.c \
    parse repl.c repl tokenize.c tokenize

all: $(TARGETS)

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

detokenize.c: \
    detokenize.nw strscan.nw
	nofake --error -R'build detokenize.c' $^ | $(SH)

detokenize: \
    detokenize.c detokenize.nw strscan.nw
	nofake --error -R'build detokenize' $^ | $(SH)

git-last-modified.sh: \
    git-last-modified.nw shell.nw
	nofake --error -R'build git-last-modified.sh' $^ | $(SH)

nofake-exec.sh: \
    nofake-exec.nw shell.nw temporary-files-shell.nw
	nofake --error -R'build nofake-exec.sh' $^ | $(SH)

nwsplit.c: \
    nwsplit.nw strscan.nw
	nofake --error -R'build nwsplit.c' $^ | $(SH)

nwsplit: \
    nwsplit.c nwsplit.nw strscan.nw
	nofake --error -R'build nwsplit' $^ | $(SH)

parse.c: \
    config.nw debug.nw parse.nw queue.nw reallocarray.nw \
    strscan.nw tkscan.nw
	nofake --error -R'build parse.c' $^ | $(SH)

parse: \
    config.nw debug.nw parse.c parse.nw queue.nw \
    reallocarray.nw strscan.nw tkscan.nw
	nofake --error -R'build parse' $^ | $(SH)

repl.c: \
    repl.nw
	nofake --error -R'build repl.c' $^ | $(SH)

repl: \
    repl.c repl.nw
	nofake --error -R'build repl' $^ | $(SH)

tokenize.c: \
    strscan.nw tokenize.nw
	nofake --error -R'build tokenize.c' $^ | $(SH)

tokenize: \
    strscan.nw tokenize.c tokenize.nw
	nofake --error -R'build tokenize' $^ | $(SH)

clean:
	-rm -f $(TARGETS)

