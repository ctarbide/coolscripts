#!/bin/sh
exec perl -lpi -e's,[ \t]+$,,' "$@"
