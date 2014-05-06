#! /bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

: ${1?"Usage: $0 <node-port>"}
NODE_PORT=${1}

echo "Running app..."

echo "Git version"
git --version || die

echo "Node version"
node --version || die

echo "Npm version"
npm --version || die

echo "Updating from git"
git pull || die

echo "Setting ENV variables to .bash_profile"
echo "export port=${NODE_PORT}" >> ~/.bash_profile  || die

echo "Installing npm dependencies"
npm install || die

echo "Finished installing!"

echo "Running tests"
npm test || die

echo "Running app..."
npm start || die

echo "Done."