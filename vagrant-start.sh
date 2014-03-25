#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Changing to vagrant/"
cd vagrant/ || die

echo "Taking vagrant up"
vagrant up || die

echo "SSH into vagrant"
vagrant ssh || die

echo "Destroying vagrant instance"
vagrant destroy
