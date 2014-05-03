#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Starting vagrant box..."

echo "Creating a link to the install script"
ln -f ./install-app.sh ./vagrant/install-app.sh || die

echo "Changing to vagrant/"
cd vagrant/ || die

echo "Taking vagrant up"
vagrant up || die

echo "SSH into vagrant"
vagrant ssh || die

echo "Destroying vagrant instance"
vagrant destroy

echo "Done."