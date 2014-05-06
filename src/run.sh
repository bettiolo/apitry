#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Running app..."

echo "Git version"
git --version || die

echo "Node version"
node --version || die

echo "Npm version"
npm --version || die

echo "Updating from git"
git pull || die

echo "Installing npm dependencies"
npm install || die

echo "Running tests"
npm test || die

echo "Done."