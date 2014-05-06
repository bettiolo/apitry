#! /bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Provisioning..."

echo "Updating packages"
pacman -Syu --noconfirm || die
echo "Installing git"
pacman -S git --noconfirm || die
echo "Installing NodeJs and NPM"
pacman -S nodejs --noconfirm || die
echo "Updating NPM"
npm update -g npm || die
echo "Updating glbal NPM packages"
npm update -g || die

echo "Cloning development branch"
git clone --branch develop https://github.com/bettiolo/apitry.git || die