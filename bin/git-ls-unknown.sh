#!/bin/sh
# git status --porcelain | perl -lne'next unless m{^\?\? }; print(q{/} . substr($_,3))'
git ls-files -o --exclude-standard | perl -lne'next if m{^\.gitignore$}; print(qq{/${_}})'
