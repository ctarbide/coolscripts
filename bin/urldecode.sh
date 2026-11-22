#!/bin/sh
exec perl -MCGI::Util=unescape -lne'print(unescape($_))' -- "$@"
