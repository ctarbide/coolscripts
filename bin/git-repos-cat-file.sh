#!/bin/sh

set -eu

die(){ ev=$1; shift; for msg in "$@"; do echo "${msg}"; done; exit "${ev}"; }

[ "$#" -gt 1 ] || die 1 "usage: ${0##*/} repos.git id"

GIT_DIR="${1}" exec git cat-file blob "${2}"
