#!/bin/sh

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

test -d .hg || die 1 "error: .hg directory not found"

filter_out_hg_status_expected(){
    perl -lne'
next if m{^\? \s+ \.dir-info_2[0-9\-]+_[0-9mh]+\.gz$}xi;
next if m{^\! \s+ }xi;
print;'
}

# proceed only if clean state
if hg status | filter_out_hg_status_expected | perl -lne'}{exit(!$.)'; then
    die 1 "error: working copy is not clean, do an 'hg status' to assess"
fi

stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
stamp_day=${stamp%_*}

if ! perl -le'exit(!(-f glob($ARGV[0])))' -- ".dir-info_${stamp_day}_*"; then
    dir-info-analyse.sh . | gzip -9 > ".dir-info_${stamp}.gz"
fi

if env ls -1 | perl -lne'}{exit(!$.)'; then
    die 1 'please now remove all files in current directory, except for the' \
        '    hidden file (i.e., files starting with "."), then run this' \
        '    command again'
fi

set -- # clear $@
if [ -f .hgignore ]; then set -- "$@" .hgignore; fi
if [ -f .hgtags ]; then set -- "$@" .hgtags; fi
if [ -f .hgempty ]; then set -- "$@" .hgempty; fi
if [ -f .hgeol ]; then set -- "$@" .hgeol; fi
if [ -f .cvsignore ]; then set -- "$@" .cvsignore; fi
if [ -f .gitignore ]; then set -- "$@" .gitignore; fi
if [ -d .hg ]; then set -- "$@" .hg; fi
tar -cf - .dir-info_* "$@" | gzip -9 > "hg_repos_${stamp}.tar.gz"

gzip -tv "hg_repos_${stamp}.tar.gz"

env rm -f .hgignore .hgtags .hgempty .hgeol .cvsignore .gitignore
env rm -rf .hg

cat <<EOF > "recover.sh"
#!/bin/sh
set -eu
die(){ ev=\$1; shift; for msg in "\$@"; do echo "\${msg}"; done; exit "\${ev}"; }
stamp=${stamp}
test ! -d .hg || die 1 "error: .hg directory exists (already recovered?)"
gzip -dc "hg_repos_\${stamp}.tar.gz" | tar -xf -
hg revert .
echo "all done for \"\${0##*/}\""
EOF

chmod +x "recover.sh"

echo "all done for \"${0##*/}\""
