
# automatically generated from Makefile.nw

all: \
    create-config.sh show-config.sh new-item.sh \
    make-index.sh find.sh head-README.sh \
    show-README.sh cat-README.sh nofake-exec.sh \
    repl.c git-last-modified.sh

create-config.sh: shell.nw create-config.nw
	nofake --error -R'build create-config.sh' $^ | sh -eu

show-config.sh: shell.nw create-config.nw
	nofake --error -R'build show-config.sh' $^ | sh -eu

new-item.sh: shell.nw create-config.nw new-item.nw
	nofake --error -R'build new-item.sh' $^ | sh -eu

make-index.sh: shell.nw create-config.nw make-index.nw
	nofake --error -R'build make-index.sh' $^ | sh -eu

find.sh: shell.nw create-config.nw temporary-files-shell.nw find.nw
	nofake --error -R'build find.sh' $^ | sh -eu

head-README.sh: shell.nw create-config.nw temporary-files-shell.nw head-README.nw
	nofake --error -R'build head-README.sh' $^ | sh -eu

show-README.sh: shell.nw create-config.nw temporary-files-shell.nw show-README.nw
	nofake --error -R'build show-README.sh' $^ | sh -eu

cat-README.sh: shell.nw create-config.nw temporary-files-shell.nw cat-README.nw
	nofake --error -R'build cat-README.sh' $^ | sh -eu

nofake-exec.sh: shell.nw temporary-files-shell.nw nofake-exec.nw
	nofake --error -R'build nofake-exec.sh' $^ | sh -eu

repl.c: repl.nw
	nofake --error -R'build repl.c' $^ | sh -eu

git-last-modified.sh: shell.nw git-last-modified.nw
	nofake --error -R'build git-last-modified.sh' $^ | sh -eu

