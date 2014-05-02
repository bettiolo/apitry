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
docker run -p 49200:8000 -d "bettiolo/oauth-console" || die

echo "Done."