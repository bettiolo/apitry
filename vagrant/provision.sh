#!/bin/bash

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

echo "Changing to /srv/http/"
cd /srv/http/ || die
echo "Cloning development branch"
git clone --branch develop https://github.com/bettiolo/apitry.git --depth 1 || die

echo "Changing to /srv/http/apitry/"
cd ./apitry || die
echo "Loading environment"
./get-env.sh -v || die
APITRY_ENV=$(./get-env.sh)

echo "Changing to /srv/http/apitry/src/"
cd ./src || die
echo "Installing npm dependencies"
npm install || die

echo "Changing to /srv/http/apitry/service/"
cd ../service || die
echo "Setting environment for service"
echo "APITRY_ENV=${APITRY_ENV}" >> ./environment || die
echo "Copying apitry service"
cp ./apitry.service /etc/systemd/system/ || die
echo "Enabling apitry service"
systemctl enable apitry.service || die
echo "Starting apitry service"
systemctl start apitry.service || die