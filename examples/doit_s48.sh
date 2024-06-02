#!/bin/sh
# https://ctarbide.github.io/pages/2024/2024-02-05_12h00m11_hello-worlds/
# https://github.com/ctarbide/coolscripts/blob/master/bin/nofake-exec.nw
set -eu; set -- "${0}" --ba-- "${0}" "$@" --ea--
set -- "$@" --tmp-- .input
SH=${SH:-sh -eu}; export SH
PERL=${PERL:-perl}; export PERL
exec nofake-exec.sh --error -Rprog "$@" -- ${SH}
exit 1

<<tilde>>=
(?: ~ | %7E)
@

<<filter>>=
(?: www\d*\. )?
(?: s48\.org/ )
(?! .*? (?: // | \# ))
@

<<project_name>>=

@

<<github userid>>=

@

<<unescape listing>>=
perl -MCGI::Util=unescape -lne'print(unescape($_))' | LC_ALL=C sort -u
@

<<prog>>=
set -eu
die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thisprog=${1}; shift # the initial script
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${thisprog}"`
thisdir=${thispath%/*}

LC_ALL=C
export LC_ALL

script_id=${thisprog#./}
script_id=${script_id#doit_}
script_id=${script_id%.sh}

# seeds are in 'listings' file, initial lines as '0.'

# an initial 'lynx-list-links.sh' might be needed to bootstrap 'listings' files

url_prefix='<<filter>>'
github_userid=<<github userid>>
project_name=

do_help(){
    echo "usage: "
    echo ""
    cat @<<EOF
  ${thisprog} list-all-html-links | tee gather__${script_id}.inc.sh
  ${thisprog} gather-links
  ${thisprog} list-pending-dirs
  ${thisprog} list-pending-dirs-force-https
  ${thisprog} list-pending-files
  ${thisprog} list-pending-files-force-https
  ${thisprog} list-unrelated-files
EOF
    if [ x"${github_userid}" != x ]; then
        echo ""
        echo "  ./${thisprog} list-pending-repositories"
    fi
    if [ x"${project_name}" != x ]; then
        cat @<<EOF

  ./${thisprog} list-dirs | tee gather__${script_id}.inc.sh
  ./${thisprog} gather-links
  ./${thisprog} list-files | tee locations__${script_id}.inc.sh
  ./${thisprog} resolve-locations
  ./${thisprog} download-files
EOF
    fi
    echo ""
}

if [ "${#}" -eq 0 ]; then
    do_help
    exit 1
fi

cmd=$1
shift

test -f listings || touch listings
test -f listings_curl || touch listings_curl

append(){
    echo "doing ${1}"
    lynx-list-links.sh "${1}" 1>>listings 2>>lynx-stderr || true
    # random sleep to avoid 429 "Too Many Requests"
    perl -e'select(undef, undef, undef, 1 + rand()*.5)'
}

list(){
    perl -le'
my $url = $ARGV[0];
shift(@ARGV);
while(<>){
    chomp;
    exit(0) if m{^input args: \Q${url}\E$};
}
exit(1);
' -- "${1}" listings || append "${1}"
}

append_curl_head(){
    echo "doing ${1}"
    echo "" >>listings_curl
    echo "input args: ${1}" >>listings_curl
    curl --head -sSL "${1}" 1>>listings_curl 2>>curl-stderr || true
}

curl_head(){
    perl -lne'exit if m{^input args: \Q'"${1}"'\E$}}{exit(1)' -- listings_curl || append_curl_head "${1}"
}

do_gather_links(){
    test -r "gather__${script_id}.inc.sh" || die 1 "Error, run \"./${thisprog} list-all-html-links | tee gather__${script_id}.inc.sh\" first."
    . "${thisdir}/gather__${script_id}.inc.sh"
}

list_all_urls(){
    lynx-list-paths.sh listings | perl -lpe's,^\047(.*)\047$,${1},; s,\047,%27,g' |
    <<unescape listing>> | LC_ALL=C sort -u
}

list_filtered_urls(){
    list_all_urls | perl -lne'next unless m{^ \w+ :// '"${url_prefix}"' }xi; print'
}

list_unrelated_urls(){
    lynx-list-paths.sh listings | perl -lpe's,^\047(.*)\047$,${1},; s,\047,%27,g' | LC_ALL=C sort -u |
        perl -lne'next if m{^ \w+ :// '"${url_prefix}"' }xi; print'
}

do_list_all_html_links(){
    list_filtered_urls | perl -lne'
        next if m{^ https? :// sourceforge\.net /projects/ [^/]+ /files/ }xi;
        next unless m{ (?: \.s?html? | / ) $}xi;
        print(qq{list \047${_}\047});
    '
}

do_list_pending_dirs(){
    list_filtered_urls |
        perl -lne'next unless m{^ \w+ :// ( .* / ) $}xi; print(qq{\047${_}\047}) unless -f qq{${1}index.html}' |
        filter-out-not-found-urls.sh
}

do_list_pending_dirs_force_https(){
    do_list_pending_dirs |
        perl -lpe's,^\047(.*)\047$,${1},; s,^https?://(.*)$,\047https://${1}\047,' | LC_ALL=C sort -u
}

# '.listing' files are generated by 'wget --no-remove-listing' on ftp sites

do_list_pending_files(){
    list_filtered_urls |
        perl -lne'next unless m{^ \w+ :// .+? / (?:.*/)? [^/.]* \. (?:.*\.)? [^/.]+ $}xi; print' |
        filter-out-existing-urls.sh |
        perl -lne'
            s,^\047(.*)\047$,${1},;
            ($p = $_) =~ s,^\w+://(.*),${1},;
            print(qq{\047${_}\047}) unless -f qq{${p}/.listing};
        '
}

do_list_pending_files_force_https(){
    do_list_pending_files |
        perl -lpe's,^\047(.*)\047$,${1},; s,^https?://(.*)$,\047https://${1}\047,' | LC_ALL=C sort -u
}

do_list_unrelated_files(){
    list_unrelated_urls |
        perl -lne'next unless m{^ \w+ :// .+? / (?:.*/)? [^/.]* \. (?:.*\.)? [^/.]+ $}xi; print'
}

do_list_pending_repositories(){
    lynx-list-urls.sh listings | perl -lpe's,^\047(.*)\047$,${1},; s,\047,%27,g' | LC_ALL=C sort -u |
        perl -lne'next unless m{^(https://github\.com/ '"${github_userid}"' / [^/]+ ) $}xi; print(${1});' |
        perl -lne'next unless m{^https://github\.com/ (.+?) / (.+) $}xi; $dir=qq{${1}_${2}.git}; next if -d $dir or -f qq{${dir}.skip}; print' |
        perl -lne'print(qq{git-clone-and-fetch-to-bare-repository.sh \047${_}\047})'
}

do_list_dirs(){
    list_all_urls | SUFFIX=/download INCLUDEPREFIX=no \
        filter-out-extraneous-suffixes.sh |
        perl -lne'
            next unless m{^ \047 \w+ :// sourceforge\.net /projects/ '"${project_name}"' /files/ .* / \047 $}xi;
            next if m{ (?: /stats/ | /stats/timeline ) \047 $}xi;
            print qq{list ${_}};
        '
}

do_list_files(){
    list_filtered_urls | perl -lne'
        next unless m{ :// sourceforge\.net /projects/ '"${project_name}"' /files/ .* /download $}xi;
        next if m{ /files/latest/download $}xi;
        print qq{curl_head \047${_}\047};
    '
}

do_resolve_locations(){
    test -f "locations__${script_id}.inc.sh" || touch "locations__${script_id}.inc.sh"
    . "${thisdir}/locations__${script_id}.inc.sh"
}

do_download_files(){
    sourceforge-tld-mkdirs.sh
    sourceforge-tld-list-pending.sh
    sourceforge-tld-fix-names.pl 1>&2
}

case "${cmd}" in
    gather-links)           do_gather_links;;
    list-all-html-links)    do_list_all_html_links;;
    list-pending-dirs)      do_list_pending_dirs;;
    list-pending-dirs-force-https)      do_list_pending_dirs_force_https;;
    list-pending-files)     do_list_pending_files;;
    list-pending-files-force-https)     do_list_pending_files_force_https;;
    list-unrelated-urls)   list_unrelated_urls;;
    list-unrelated-files)   do_list_unrelated_files;;

    # github repositories cloning
    list-pending-repositories)  do_list_pending_repositories;;

    # sourceforge files download
    list-dirs)              do_list_dirs;;
    list-files)             do_list_files;;
    resolve-locations)      do_resolve_locations;;
    download-files)         do_download_files;;

    cycle)
        do_list_all_html_links > "gather__${script_id}.inc.sh"
        do_gather_links
        ;;

    help)                   do_help;;
    *)
        die 1 "error: unknown command: ${cmd}"
        ;;
esac
@
