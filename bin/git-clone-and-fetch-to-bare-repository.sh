#!/bin/sh
set -eu
umask 022
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -eq 1 -o "$#" -eq 2 ] || die 1 "usage: ${0##*/} git-repos-url [output.git]"

repos=$1

if echo "${repos}" | perl -ne'exit 0 if m{^\w+://github\.com/} and not m{(\w[\w\-.]*)/([\w.][\w\-.]*\.git)$}; exit 1'; then
    repos=${repos}.git
elif echo "${repos}" | perl -ne'exit 0 if m{^\w+://gitlab\.com/} and not m{(\w[\w\-.]*)/([\w.][\w\-.]*\.git)$}; exit 1'; then
    repos=${repos}.git
fi

outdir=${2:-}

if [ x"${outdir}" = x ]; then
    if perl -le'exit($ARGV[0] !~ m{^ https? :// git\.savannah\.gnu\.org /r/ [^/]+ \.git$}xi)' -- "${repos}"; then
        # http://git.savannah.gnu.org/r/m4.git
        outdir=org_gnu_savannah_`perl -le'print($ARGV[0] =~ m{^ https? :// git\.savannah\.gnu\.org /r/ ( [^/]+ ) \.git$}xi)' -- "${repos}"`
    elif echo "${repos}" | perl -ne'exit 1 unless m@^\w+://github\.com/(\w[\w\-.]*)/([\w.][\w\-.]*)$@'; then
        outdir=`echo "$repos" | perl -lpe's@^\w+://github\.com/(\w[\w\-.]*)/([\w.][\w\-.]*)$@${1}_${2}@'`
    elif echo "${repos}" | perl -ne'exit 1 unless m@^\w+://gitlab\.com/(\w[\w\-.]*)/([\w.][\w\-.]*)$@'; then
        outdir=`echo "$repos" | perl -lpe's@^\w+://gitlab\.com/(\w[\w\-.]*)/([\w.][\w\-.]*)$@${1}_${2}@'`
    elif echo "${repos}" | perl -ne'exit 1 unless m@/mainline\.git$@'; then
        outdir=`echo "$repos" | perl -lpe's@.*/([_a-zA-Z0-9][_a-zA-Z0-9\-.]*)/(mainline\.git)$@${1}_${2}@'`
    else
        outdir=`echo "$repos" | perl -pe's,/*$,,'`
        outdir=${outdir##*/}
    fi
    if [ x"${outdir##*.}" != x"git" ]; then
        outdir="${outdir}.git"
    fi
else
    if [ x"${outdir##*.}" != x"git" ]; then
        die 1 "Error, output directory (bare git repository) has to end with \"\.git\"."
    fi
fi

if test -d "${outdir}"; then
    test -f "${outdir}/config"
    test -d "${outdir}/hooks"
else
    git clone --bare "${repos}" "${outdir}"
fi

find "${outdir}/hooks/" -name '*.sample' | xargs rm -f --

cat <<EOF > "${outdir}-update.sh"
#!/bin/sh
set -eu
utcstamp=\`date --utc '+%Y%m%dT%H%M%S %N UTC' | perl -lane'print(\$F[0],sprintf(q{%03i},\$F[1]/1000000),\$F[2])'\`
GIT_DIR="${outdir}"
export GIT_DIR
git fetch '${repos}' 'refs/heads/*:refs/heads/*'
branch=
if git rev-parse --quiet --verify --symbolic-full-name master; then
    branch=master
elif git rev-parse --quiet --verify --symbolic-full-name default; then
    branch=default
elif git rev-parse --quiet --verify --symbolic-full-name development; then
    branch=development
elif git rev-parse --quiet --verify --symbolic-full-name develop; then
    branch=develop
elif git rev-parse --quiet --verify --symbolic-full-name dev; then
    branch=dev
elif git rev-parse --quiet --verify --symbolic-full-name current; then
    branch=current
elif git rev-parse --quiet --verify --symbolic-full-name main; then
    # life finds a way.. to self select
    branch=main
fi
if [ x"\${branch}" != x ]; then
    echo "using branch: \"\${branch}\"" > "\${GIT_DIR}-log-\${utcstamp}"
    echo >> "\${GIT_DIR}-log-\${utcstamp}"
    git log -5 refs/heads/"\${branch}" >> "\${GIT_DIR}-log-\${utcstamp}"
    chmod a-w "\${GIT_DIR}-log-\${utcstamp}"
fi
git repack -d
git prune
echo "All done for \"\${0##*/}\", branch \"\${branch}\"."
EOF

chmod +x "${outdir}-update.sh"

"./${outdir}-update.sh"

echo "all done for \"${0##*/}\""
