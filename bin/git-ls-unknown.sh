#!/bin/sh
git ls-files -o --exclude-standard | perl -lne'print(qq{/${_}})'
