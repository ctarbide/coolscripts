
# automatically generated from Makefile.nw

SH = sh

SOURCES = \
    Makefile.nw create-config.nw nofake-exec.nw \
    repl.nw git-last-modified.nw nwsplit.nw

TARGETS = \
    create-config.sh show-config.sh new-item.sh \
    make-index.sh find.sh head-README.sh \
    show-README.sh cat-README.sh nofake-exec.sh \
    repl.c repl git-last-modified.sh \
    nwsplit.c nwsplit

all: $(TARGETS)

create-config.sh: shell.nw create-config.nw
	@nofake --error -R'build create-config.sh' $(SOURCES) | $(SH) -eu

show-config.sh: shell.nw create-config.nw
	@nofake --error -R'build show-config.sh' $(SOURCES) | $(SH) -eu

new-item.sh: shell.nw create-config.nw new-item.nw
	@nofake --error -R'build new-item.sh' $(SOURCES) | $(SH) -eu

make-index.sh: shell.nw create-config.nw make-index.nw
	@nofake --error -R'build make-index.sh' $(SOURCES) | $(SH) -eu

find.sh: shell.nw create-config.nw temporary-files-shell.nw find.nw
	@nofake --error -R'build find.sh' $(SOURCES) | $(SH) -eu

head-README.sh: shell.nw create-config.nw temporary-files-shell.nw head-README.nw
	@nofake --error -R'build head-README.sh' $(SOURCES) | $(SH) -eu

show-README.sh: shell.nw create-config.nw temporary-files-shell.nw show-README.nw
	@nofake --error -R'build show-README.sh' $(SOURCES) | $(SH) -eu

cat-README.sh: shell.nw create-config.nw temporary-files-shell.nw cat-README.nw
	@nofake --error -R'build cat-README.sh' $(SOURCES) | $(SH) -eu

nofake-exec.sh: shell.nw temporary-files-shell.nw nofake-exec.nw
	@nofake --error -R'build nofake-exec.sh' $(SOURCES) | $(SH) -eu

repl.c: repl.nw
	@nofake --error -R'build repl.c' $(SOURCES) | $(SH) -eu

repl: repl.c
	@nofake --error -R'build repl' $(SOURCES) | $(SH) -eu

git-last-modified.sh: shell.nw git-last-modified.nw
	@nofake --error -R'build git-last-modified.sh' $(SOURCES) | $(SH) -eu

nwsplit.c: nwsplit.nw
	@nofake --error -R'build nwsplit.c' $(SOURCES) | $(SH) -eu

nwsplit: nwsplit.c
	@nofake --error -R'build nwsplit' $(SOURCES) | $(SH) -eu

clean:
	-rm -f $(TARGETS)

