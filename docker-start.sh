#!/bin/sh

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Starting docker image..."

echo "Changing to docker/"
cd docker/ || die

echo "Starting docker"
docker run -t -i -p 49200:8002 "bettiolo/apitry" || die

echo "Done."