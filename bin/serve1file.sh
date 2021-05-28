#!/bin/sh

# usage: ./serve1file.sh serve1file.sh 6789

# test with socat: sleep 1 | socat -t999999999 - tcp:127.0.0.1:6789 | cat -vet
# test with curl: curl -s --dump-header - http://127.0.0.1:6789/

set -eu #x

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}" >&2; done; exit "${ev}"; }

if [ x"${FILE:-}" = x ]; then
    if [ x"${1:-}" != x ]; then
        FILE="${1}" exec socat -t999999999 "tcp-l:${2:-8021},reuseaddr,fork,bind=0.0.0.0" exec:"${0}"
    else
        die 1 "error: usage ${0##*/} file [port]"
    fi
    exit 0
fi

test -f "${FILE}" || die 1 "error: file \"${FILE}\" does not exist"

case "${FILE##*.}" in
    html)   CONTENT_TYPE='text/html';;
    xhtml)  CONTENT_TYPE='application/xhtml+xml';;
    txt)    CONTENT_TYPE='text/plain';;
    *)      CONTENT_TYPE='application/octet-stream';;
esac

export CONTENT_TYPE

FILENAME=${FILE##*/}
export FILENAME

# read request header, will simply stop on first empty line
perl -lne'exit if m{^\r?$}; s,[^\040-\176],.,g; print STDERR (qq{$$ got [$_]})'

exec perl -0777 -pe'BEGIN{
  print(qq{HTTP/1.1 200 OK\r\n});
  print(qq{Connection: close\r\n});
  printf(qq{Content-Type: %s\r\n}, $ENV{CONTENT_TYPE});
  printf(qq{Content-Length: %s\r\n}, (stat($ARGV[0]))[7]);
  printf(qq{Content-Disposition: attachment; filename="%s"\r\n}, $ENV{FILENAME});
  print(qq{\r\n});
}' -- "${FILE}"
