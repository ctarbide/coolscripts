#!/bin/sh
set -eu
containername=$1; shift
exec docker container inspect -f '{{range .HostConfig.Binds}}{{. | printf "%s\n"}}{{end}}' "${containername}"
