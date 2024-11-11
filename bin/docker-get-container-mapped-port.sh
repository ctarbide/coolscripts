#!/bin/sh
# usage: docker-get-container-mapped-port.sh nginx 8080/tcp
set -eu
containername=$1; shift
exposedport=$1; shift
exec docker container inspect -f '{{ (index (index .NetworkSettings.Ports "'"${exposedport}"'") 0).HostPort }}' "${containername}"
