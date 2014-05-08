#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

# Loading the branch name the standard way, does not work if a specific commit has been checked out
BRANCH=$(git symbolic-ref -q HEAD | cut -d "/" -f 3)
# Support for Travis CI
[ -z "${BRANCH}" ] && BRANCH=${TRAVIS_BRANCH}
# Support for codeship.io
[ -z "${BRANCH}" ] && BRANCH=${CI_BRANCH}
# If a tag has been checked out, the branch will be detached
[ -z "${BRANCH}" ] && BRANCH=$(git describe --exact-match --tags HEAD)

echo "${BRANCH}"