#!/bin/sh

# reference: ~/last-class/lisp/gregcman/doit_gregcman.sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- "${0}"`
thisprog=${thispath##*/}
thisdir=${thispath%/*}

LC_ALL=C
export LC_ALL

script_id=${thisprog#doit_}
script_id=${script_id%.sh}

# seeds are in 'listings' file, initial lines as '0.'

# an initial 'lynx-list-links.sh' might be needed to bootstrap 'listings' files

url_prefix='(?:www\d*\.)? (?: s48\.org/ ) (?!.*?//)'
github_userid=
project_name=

do_help(){
    echo "usage: "
    echo ""
    cat <<EOF
  ./${thisprog} gather-links
  ./${thisprog} list-all-html-links | tee gather__${script_id}.inc.sh
  ./${thisprog} list-pending-dirs
  ./${thisprog} list-pending-files
  ./${thisprog} list-pending-files | download-full-dirs.sh
  ./${thisprog} list-unrelated-files
EOF
    if [ x"${github_userid}" != x ]; then
        echo ""
        echo "  ./${thisprog} list-pending-repositories"
    fi
    if [ x"${project_name}" != x ]; then
        cat <<EOF

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
    touch "gather__${script_id}.inc.sh"
    . "${thisdir}/gather__${script_id}.inc.sh"
}

do_list_all_html_links(){
    lynx-list-urls.sh listings |
        perl -lne'next unless m{:// '"${url_prefix}"' }xi; print' |
        perl -lpe's,\047,%27,g' | LC_ALL=C sort -u |
        perl -lne'next unless m{(?: \.s?html? | / ) $}xi; print(qq{    list \047${_}\047})'
}

do_list_pending_dirs(){
    lynx-list-urls.sh listings |
        perl -lpe's,\047,%27,g' | LC_ALL=C sort -u |
        perl -lne'next unless m{:// ( '"${url_prefix}"' / (?:.*/)? ) $}xi; print(qq{\047${_}\047}) unless -f qq{${1}/index.html}'
}

# '.listing' files are generated by 'wget --no-remove-listing' on ftp sites

do_list_pending_files(){
    lynx-list-urls.sh listings |
        perl -lpe's,\047,%27,g' | LC_ALL=C sort -u |
        perl -lne'next unless m{:// '"${url_prefix}"' (?:.*/)? [^/.]* \. (?:.*\.)? [^/.]+ $}xi; print' |
        filter-out-existing-urls.sh |
        perl -lne'($p = $_) =~ s,^\w+://(.*),$1,; print($_) unless -f qq{${p}/.listing}' |
        perl -lne'print(qq{\047${_}\047})'
}

do_list_unrelated_files(){
    lynx-list-urls.sh listings |
        perl -lne'next if m{:// '"${url_prefix}"' (?:.*/)? [^/.]* \. (?:.*\.)? [^/.]+ $}xi; print'
}

do_list_pending_repositories(){
    lynx-list-urls.sh listings |
        perl -lne'next unless m{^(https://github.com/ '"${github_userid}"' / [^/]+ ) $}xi; print(${1});' |
        perl -lne'next unless m{^https://github.com/ (.+?) / (.+) $}xi; $dir=qq{${1}_${2}.git}; next if -d $dir or -f qq{${dir}.skip}; print' |
        perl -lne'print(qq{  git-clone-and-fetch-to-bare-repository.sh \047${_}\047})'
}

do_list_files(){
  lynx-list-urls.sh listings |
      perl -lne'next unless m {:// sourceforge\.net /projects/ '"${project_name}"' /files/ .* /download $}xi; print' |
      perl -lpe's,^http://,https://, unless m{\.sourceforge\.net/}' |
      perl -lne'next if m{/files/latest/download$}; print' |
      perl -lne'print(qq{  curl_head \047${_}\047})'
}

do_resolve_locations(){
    touch "locations__${script_id}.inc.sh"
    . "${thisdir}/locations__${script_id}.inc.sh"
}

do_download_files(){
    sourceforge-tld-mkdirs.sh
    sourceforge-tld-list-pending.sh
    sourceforge-tld-fix-names.pl 1>&2
}

case "${cmd}" in
    gather-links)          do_gather_links;;
    list-all-html-links)   do_list_all_html_links;;
    list-pending-dirs)     do_list_pending_dirs;;
    list-pending-files)    do_list_pending_files;;
    list-unrelated-files)  do_list_unrelated_files;;

    # github repositories cloning
    list-pending-repositories)     do_list_pending_repositories;;

    # sourceforge files download
    list-files)            do_list_files;;
    resolve-locations)     do_resolve_locations;;
    download-files)        do_download_files;;

    help)                  do_help;;
    *)
        die 1 "error: unknown command: ${cmd}"
        ;;
esac