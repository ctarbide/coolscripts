#!/bin/sh
# perl -ne'chomp;print;last' | exec xsel -ib
perl -ne'chomp;print;last' | exec xclip -i -selection clipboard
