#!/bin/sh
# usage: ./docker-cwd.sh --rm alpine:3.12 sh -x -c 'date > hi.txt'
# usage: seq 10 | ./docker-cwd.sh --rm -i alpine:3.12 wc -l
# usage: ./docker-cwd.sh --rm -it alpine:3.12 sh -c 'test -t 0 && echo tty'
pwd=`pwd`
exec docker run --user "$(id -u):$(id -g)" -v "${pwd}:${pwd}" -w "${pwd}" "$@"
