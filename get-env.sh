#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

if [ "$1" = "-v" ]
then
	VERBOSE=1
fi

BRANCH=$(./get-branch.sh)

echoEnvironment () {
	local env=$1
	[ -z "${env}" ] && env=unknown
	if [[ ${VERBOSE} -eq 1 ]]
	then
		echo "Environment: ${env}"
		echo "Current branch: ${BRANCH}"
	else
		echo "${env}"
	fi
	[ "${env}" = "unknown" ] && exit 1
	exit 0
}

TAG_EXPR='^v[0-9]+\.[0-9]+\.[0-9]+$'
if [[ "${BRANCH}" =~ ${TAG_EXPR} ]]
then
	echoEnvironment "production"
fi

if [ "${BRANCH}" = "master" ]
then
	echoEnvironment "staging"
fi

if [ "${BRANCH}" = "develop" ]
then
	echoEnvironment "development"
	# echo "integration" if docker/vagrant
fi

echoEnvironment "unknown"
