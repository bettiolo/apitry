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

# Loading the branch name the standard way, does not work if a specific commit has been checked out
BRANCH=$(git symbolic-ref -q HEAD | cut -d "/" -f 3)
# Support for Travis CI
[ -z "${BRANCH}" ] && BRANCH=${TRAVIS_BRANCH}
# Support for codeship.io
[ -z "${BRANCH}" ] && BRANCH=${CI_BRANCH}
# If a tag has been checked out, the branch will be detached
[ -z "${BRANCH}" ] && BRANCH=$(git describe --exact-match --tags HEAD)

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
