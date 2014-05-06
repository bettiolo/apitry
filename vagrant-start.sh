#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Starting vagrant box..."

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

echo "SSH into vagrant"
vagrant ssh -c /srv/http/apitry/src/run.sh || die

echo "Rolling back changes"
vagrant sandbox rollback

#echo "Suspending vagrant"
#vagrant suspend || die

#echo "Stopping vagrant"
#vagrant halt || die

echo "Done."