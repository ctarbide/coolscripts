
# automatically generated from Makefile.nw

SH = sh -eu

SOURCES = \
    Makefile.nw create-config.nw nofake-exec.nw repl.nw git-last-modified.nw \
    nwsplit.nw

TARGETS = \
    create-config.sh show-config.sh new-item.sh make-index.sh find.sh \
    head-README.sh show-README.sh cat-README.sh nofake-exec.sh repl.c \
    repl git-last-modified.sh nwsplit.c nwsplit

all: $(TARGETS)

create-config.sh: \
    shell.nw create-config.nw
	@nofake --error -R'build create-config.sh' $(SOURCES) | $(SH)

show-config.sh: \
    shell.nw create-config.nw
	@nofake --error -R'build show-config.sh' $(SOURCES) | $(SH)

new-item.sh: \
    shell.nw create-config.nw new-item.nw
	@nofake --error -R'build new-item.sh' $(SOURCES) | $(SH)

make-index.sh: \
    shell.nw create-config.nw make-index.nw
	@nofake --error -R'build make-index.sh' $(SOURCES) | $(SH)

find.sh: \
    shell.nw create-config.nw temporary-files-shell.nw find.nw
	@nofake --error -R'build find.sh' $(SOURCES) | $(SH)

head-README.sh: \
    shell.nw create-config.nw temporary-files-shell.nw head-README.nw
	@nofake --error -R'build head-README.sh' $(SOURCES) | $(SH)

show-README.sh: \
    shell.nw create-config.nw temporary-files-shell.nw show-README.nw
	@nofake --error -R'build show-README.sh' $(SOURCES) | $(SH)

cat-README.sh: \
    shell.nw create-config.nw temporary-files-shell.nw cat-README.nw
	@nofake --error -R'build cat-README.sh' $(SOURCES) | $(SH)

nofake-exec.sh: \
    shell.nw temporary-files-shell.nw nofake-exec.nw
	@nofake --error -R'build nofake-exec.sh' $(SOURCES) | $(SH)

repl.c: \
    repl.nw
	@nofake --error -R'build repl.c' $(SOURCES) | $(SH)

repl: \
    repl.c
	@nofake --error -R'build repl' $(SOURCES) | $(SH)

git-last-modified.sh: \
    shell.nw git-last-modified.nw
	@nofake --error -R'build git-last-modified.sh' $(SOURCES) | $(SH)

nwsplit.c: \
    nwsplit.nw strscan.nw
	@nofake --error -R'build nwsplit.c' $(SOURCES) | $(SH)

nwsplit: \
    nwsplit.c
	@nofake --error -R'build nwsplit' $(SOURCES) | $(SH)

clean:
	-rm -f $(TARGETS)

