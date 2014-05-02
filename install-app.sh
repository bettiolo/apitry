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

echo "Setting ENV variables to .bash_profile"
echo "export port=${NODE_PORT}" >> ~/.bash_profile  || die

if [ ! -d "packer-arch/" ]; then
	echo "Cloning oauth-console"
	git clone https://github.com/bettiolo/oauth-console.git || die
fi

echo "Changing to ./oauth-console"
cd ./oauth-console/src || die

echo "Pulling latest oauth-console"
git pull || die

echo "Installing npm dependencies"
npm install || die

echo "Node version"
node --version || die

echo "Npm version"
npm --version || die

echo "Finished installing!"