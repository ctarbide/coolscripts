#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

test ! -d clone.git || die 1 "error: clone.git already exists"

git clone --bare "`git-dir.sh`" clone.git

cat << 'EOF' > clone.git/hooks/post-update
#!/bin/sh
# pack, clean redundant object and
# update server information
exec git-repack -d
EOF
chmod +x clone.git/hooks/post-update
cd clone.git
rm -f hooks/*.sample
git --bare repack -d
