
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
	@nofake --error -R'build create-config.sh' $(SOURCES) | $(SH)

show-config.sh: \
    create-config.nw shell.nw
	@nofake --error -R'build show-config.sh' $(SOURCES) | $(SH)

new-item.sh: \
    create-config.nw new-item.nw shell.nw
	@nofake --error -R'build new-item.sh' $(SOURCES) | $(SH)

make-index.sh: \
    create-config.nw make-index.nw shell.nw
	@nofake --error -R'build make-index.sh' $(SOURCES) | $(SH)

find.sh: \
    create-config.nw find.nw shell.nw temporary-files-shell.nw
	@nofake --error -R'build find.sh' $(SOURCES) | $(SH)

head-README.sh: \
    create-config.nw head-README.nw shell.nw temporary-files-shell.nw
	@nofake --error -R'build head-README.sh' $(SOURCES) | $(SH)

show-README.sh: \
    create-config.nw shell.nw show-README.nw temporary-files-shell.nw
	@nofake --error -R'build show-README.sh' $(SOURCES) | $(SH)

cat-README.sh: \
    cat-README.nw create-config.nw shell.nw temporary-files-shell.nw
	@nofake --error -R'build cat-README.sh' $(SOURCES) | $(SH)

detokenize.c: \
    detokenize.nw strscan.nw
	@nofake --error -R'build detokenize.c' $(SOURCES) | $(SH)

detokenize: \
    detokenize.c
	@nofake --error -R'build detokenize' $(SOURCES) | $(SH)

git-last-modified.sh: \
    git-last-modified.nw shell.nw
	@nofake --error -R'build git-last-modified.sh' $(SOURCES) | $(SH)

nofake-exec.sh: \
    nofake-exec.nw shell.nw temporary-files-shell.nw
	@nofake --error -R'build nofake-exec.sh' $(SOURCES) | $(SH)

nwsplit.c: \
    nwsplit.nw strscan.nw
	@nofake --error -R'build nwsplit.c' $(SOURCES) | $(SH)

nwsplit: \
    nwsplit.c
	@nofake --error -R'build nwsplit' $(SOURCES) | $(SH)

parse.c: \
    debug.nw parse.nw queue.nw reallocarray.nw strscan.nw \
    tkscan.nw
	@nofake --error -R'build parse.c' $(SOURCES) | $(SH)

parse: \
    parse.c
	@nofake --error -R'build parse' $(SOURCES) | $(SH)

repl.c: \
    repl.nw
	@nofake --error -R'build repl.c' $(SOURCES) | $(SH)

repl: \
    repl.c
	@nofake --error -R'build repl' $(SOURCES) | $(SH)

tokenize.c: \
    strscan.nw tokenize.nw
	@nofake --error -R'build tokenize.c' $(SOURCES) | $(SH)

tokenize: \
    tokenize.c
	@nofake --error -R'build tokenize' $(SOURCES) | $(SH)

clean:
	-rm -f $(TARGETS)

