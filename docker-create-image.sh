#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Creating docker image..."

echo "Changing to docker/"
cd docker/ || die

echo "Building docker image"
docker build -t "bettiolo/oauth-console" . || die

echo "Done."
