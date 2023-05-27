#!/bin/sh
set -eu
thispath=`perl -MFile::Spec::Functions=rel2abs,canonpath -le'print(canonpath(rel2abs(\$ARGV[0])))' -- .`
exec tmux rename-window "${thispath##*/}"
