#!/bin/sh
set -eu
if [ "x${2:-}" != x ]; then
  networkname=$1; shift
  containername=$1; shift
  exec docker container inspect -f '{{(index (.NetworkSettings.Networks) "'"${networkname}"'").IPAddress}}' "${containername}"
else
  containername=$1; shift
  exec docker container inspect -f '{{.NetworkSettings.IPAddress}}' "${containername}"
fi
