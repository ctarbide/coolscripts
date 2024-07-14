#!/bin/sh
set -eu

run_test(){
    prefix=$1; shift
    echo "**** testing \"${prefix}\""
    cat "${prefix}.input" | normalize-args.sh - >"${prefix}.got"
    if ! cmp "${prefix}.expected" "${prefix}.got"; then
        colordiff -u "${prefix}.expected" "${prefix}.got"
    fi
}

run_test ./normalize-args_test1
run_test ./normalize-args_test2

# perl -lpe'$_ = qq{ ${_} }' <normalize-args_test1.input >normalize-args_test3.input
run_test ./normalize-args_test3

echo all pass
