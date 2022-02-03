#!/bin/sh
set -eux
out=${0##*/build-}
out=${HOME}/${out%.sh}
cat << 'EOF' | gcc -Wall -include stdio.h -include string.h -o "${out}" -x c -
int main(int argc, char **argv) {
  int i = 0;
  for (; i < argc; i++)
    fprintf(stdout, "[%d:%s]", i, argv[i]);
  fprintf(stdout, "\n");
  return 0;
}
EOF
