#!/bin/sh
set -eu
list_mounts_of_image(){
    image=$1
    docker ps --no-trunc --format '{{if eq .Image "'"${image}"'"}}{{range (split .Mounts ",")}}{{. | printf `%s\n`}}{{end}}{{end}}'
}
list_mounts_of_image "${1:-}"
