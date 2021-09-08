#!/bin/sh
exec perl -lne'printf(qq{%4s  %s\n}, $., $_)' -- "$@"
