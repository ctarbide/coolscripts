#!/bin/sh
perl -ne'chomp;print;last' | exec xsel -ib
