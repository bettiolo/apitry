#! /bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

: ${1?"Usage: $0 <node-port>"}
NODE_PORT=${1}

echo "Installing..."

echo "Cloning repository"
git clone --branch develop https://github.com/bettiolo/apitry.git || die

echo "Node version"
node --version || die

echo "Npm version"
npm --version || die

echo "Setting ENV variables to .bash_profile"
echo "export port=${NODE_PORT}" >> ~/.bash_profile  || die

echo "Changing to ./apitry/src"
cd ./apitry/src || die

# echo "Pulling latest apitry"
# git pull || die

echo "Installing npm dependencies"
npm install || die

echo "Finished installing!"

echo "Creating bash login script to run tests"
echo "cd ./apitry/src/" >> ~/.bash_login
echo "npm test" >> ~/.bash_login

echo "Created."