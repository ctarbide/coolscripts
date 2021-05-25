#!/bin/sh
set -eu #x
stamp=`date '+%Y-%m-%d_%Hh%Mm%S'`
pwd=`pwd`
thisdir=${pwd##*/}
cat<<EOF
# -*- mode:org; coding:utf-8-unix -*-

#+TITLE: ${stamp}_${thisdir}
#+STARTUP: indent

* References

- 


* Notes

EOF
