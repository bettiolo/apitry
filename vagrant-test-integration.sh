#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

./vagrant-start-integration.sh || die

if [ "$1" = "-u" ]
then
	UPDATE=1
fi

echo "Executing integration tests in vagrant..."

echo "Changing to vagrant/"
cd vagrant/ || die

echo "SSH into vagrant"
vagrant ssh -c /srv/http/apitry/src/run.sh || die

if [[ ${UPDATE} -eq 1 ]]
then
	echo "Commiting changes"
	vagrant sandbox commit
else
	echo "Rolling back changes"
	vagrant sandbox rollback
fi

#echo "Suspending vagrant"
#vagrant suspend || die

#echo "Stopping vagrant"
#vagrant halt || die

echo "Done."