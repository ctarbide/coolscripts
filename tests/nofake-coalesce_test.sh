#!/bin/sh
set -eu

run_test(){
    prefix=$1; shift
    echo "**** testing \"${prefix}\""
    cat "${prefix}.nw" | nofake-coalesce.pl - >"${prefix}.got"
    if ! cmp "${prefix}.expected" "${prefix}.got"; then
        colordiff -u "${prefix}.expected" "${prefix}.got"
    fi
}

run_test nofake-coalesce_test1
run_test nofake-coalesce_test2
run_test nofake-coalesce_test3
run_test nofake-coalesce_test4
run_test nofake-coalesce_test5
run_test nofake-coalesce_test6
run_test nofake-coalesce_test7
run_test nofake-coalesce_test8
run_test nofake-coalesce_test9
run_test nofake-coalesce_test10
run_test nofake-coalesce_test11
run_test nofake-coalesce_test12

echo all pass
