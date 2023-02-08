#!/bin/sh
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }
tmpfiles=
rm_tmpfiles(){
    eval "set -- ${tmpfiles}"
    rm -f -- "$@"
}
# 0:exit, 1:hup, 2:int, 3:quit, 15:term
trap 'rm_tmpfiles' 0 1 2 3 15
temporary_file(){
    if type mktemp >/dev/null 2>&1; then
        tmpfile=`mktemp`
    elif type roll-2dice.sh >/dev/null 2>&1; then
        tmpfile="/tmp/tmp.`roll-2dice.sh 0a | head -n12 | perl -pe chomp`"
        ( umask 0177; : > "${tmpfile}" )
    else
        die 1 'error: mktemp not found'
    fi
    echo "${tmpfile}"
}
for arg do
    case "${arg}" in
    --dry-run|-n)
        die 1 "error: option --dry-run/-n invalidates ${0##*/} purpose"
        ;;
    esac
done
tmpfile=`temporary_file`
tmpfiles="${tmpfiles} '${tmpfile}'"
rsync --dry-run "$@" | perl -lne'next if m{/$}; print' > "${tmpfile}"
no_changes_to_sync(){
    perl -lne'
while ( m{^ \s \d+ \s files \.\.\. \015 }xi ) { s,^.*?\015,, };
next if m{^ \s* $}xi;
next if m{^ building \s file \s list .* $}xi;
next if m{^ sending \s incremental \s file \s list $}xi;
next if m{^ receiving \s file \s list \s \.\.\. .* $}xi;
next if m{^ \d+ \s files \s to \s consider \s* $}xi;
last if m{^ sent \s \d[\d,]* \s bytes \s .* $}xi;
exit 1;
' < "${tmpfile}"
}
if no_changes_to_sync; then
    echo "no changes"
elif [ -t 1 ]; then
    cat "${tmpfile}"
    echo 'confirm? (type "yes" to confirm)'
    read ans
    if [ x"${ans}" = xyes ]; then
        rsync "$@"
    else
        echo "not syncing"
    fi
else
    cat "${tmpfile}"
fi
