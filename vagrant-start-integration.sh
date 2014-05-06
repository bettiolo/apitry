#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Starting integration environment in vagrant..."

echo "Changing to vagrant/"
cd vagrant/ || die

echo "Taking vagrant up"
vagrant up || die

echo "Checking sandbox status"
SANDBOX_STATUS=$(vagrant sandbox status) || die
if [ "$SANDBOX_STATUS" = "[default] Sandbox mode is off" ]
then
	echo "Creating snapshot"
	vagrant sandbox on
else
	echo "Snapshot already created"
fi

echo "Done."