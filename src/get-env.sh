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

BRANCH=$(CI_BRANCH)
[ -z "${BRANCH}" ] && BRANCH=$(git symbolic-ref --short -q HEAD)
[ -z "${BRANCH}" ] && TAG=$(git describe --exact-match --tags HEAD)

echoEnvironment () {
	local env=$1
	[ -z "${env}" ] && env=unknown
	if [[ ${VERBOSE} -eq 1 ]]
	then
		echo "Environment: ${env}"
		[ -n "${BRANCH}" ] && echo "Current branch: ${BRANCH}"
		[ -n "${TAG}" ] && echo "Current tag: ${TAG}"
	else
		echo "${env}"
	fi
	[ "${env}" = "unknown" ] && exit 1
	exit 0
}

if [ -z ${BRANCH} ]
then
	TAG_EXPR='^v[0-9]+\.[0-9]+\.[0-9]+$'
	if [[ "${TAG}" =~ ${TAG_EXPR} ]]
	then
		echoEnvironment "production"
	fi
fi

if [ "${BRANCH}" = "stable" ]
then
	echoEnvironment "staging"
fi

if [ "${BRANCH}" = "master" ]
then
	echoEnvironment "development"
	# echo "integration" if docker/vagrant
fi

echoEnvironment "unknown"
