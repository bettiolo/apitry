#!/bin/sh

[ "$#" -eq 1 ] || { echo "Usage: ${0} <path-to-publishsettings>" >&2; exit 1; }

PUBLISHSETTINGS=`pwd`/${1}

echo "Installing Azure command line tools"
# npm install azure-cli --global || { echo "Failed, aborting." >&2; exit 1; }

echo "Importing Azure account credentials: ${PUBLISHSETTINGS}"
azure account import ${PUBLISHSETTINGS} || { echo "Failed, aborting." >&2; exit 1; }

echo "Listing Azure sites"
SITES=`azure site list` || { echo "Failed, aborting." >&2; exit 1; }

SITE_PREFIX=oauth-console
SITE_NAME_GREEN=${SITE_PREFIX}-GREEN
SITE_NAME_BLUE=${SITE_PREFIX}-BLUE
INSTANCES_RUNNING=0

if echo "${SITES}" | grep -Eq "^data:\s+oauth-console-GREEN\s+.*Running"
then
	echo "GREEN instance running"
	INSTANCES_RUNNING=$[${INSTANCES_RUNNING} + 1]
else
	echo "GREEN instance NOT running"
	SITE_NAME=${SITE_NAME_GREEN}
fi

if echo "${SITES}" | grep -Eq "data:\s+${SITE_NAME_BLUE}\s+.*Running"
then
	echo "BLUE instance running"
	INSTANCES_RUNNING=$[${INSTANCES_RUNNING} + 1]
else
	echo "BLUE instance NOT running"
	SITE_NAME=${SITE_NAME_BLUE}
fi

if [ ${INSTANCES_RUNNING} -eq 0 ]
then
	echo "No instance running, default to GREEN"
	SITE_NAME=${SITE_NAME_GREEN}
fi

if [ ${INSTANCES_RUNNING} -eq 2 ]
then
	echo "Too many instances running, at least one should not be running"
	echo "Failed, aborting." >&2
	exit 1
fi

echo "Creating Azure site: ${SITE_NAME}"
azure site create --location "West Europe" --git ${SITE_NAME} || { echo "Failed, aborting." >&2; exit 1; }

echo "Disabling PHP"
azure site set --php-version off ${SITE_NAME} || { echo "Failed, aborting." >&2; exit 1; }

# echo "Enabling Web Sockets"
# azure site set -w ${SITE_NAME} || { echo "Failed, aborting." >&2; exit 1; }

echo "Getting Azure site data"
SITE_DATA=`azure site show -d ${SITE_NAME}` || { echo "Failed, aborting." >&2; exit 1; }
SITE_USERNAME=`echo "${SITE_DATA}" | grep -Eo "Config publishingUserName .+$" | cut -d " " -f 3`
SITE_PASSWORD=`echo "${SITE_DATA}" | grep -Eo "Config publishingPassword .+$" | cut -d " " -f 3`

echo "Publishing Username: ${SITE_USERNAME}"
echo "Publishing Password: ${SITE_PASSWORD}"

REMOTE_URL="https://${SITE_USERNAME}:${SITE_PASSWORD}@`git ls-remote --get-url azure | cut -d @ -f 2`"
echo "Changing 'azure' remote url to: ${REMOTE_URL}"
git remote set-url azure "${REMOTE_URL}" || { echo "Failed, aborting." >&2; exit 1; }

echo "Pushing to 'azure' remote"
git push azure master || { echo "Failed, aborting." >&2; exit 1; }

echo "Deleting 'azure' remote"
git remote remove azure || { echo "Failed, aborting." >&2; exit 1; }

echo "Clearing imported Azure account"
azure account clear || { echo "Failed, aborting." >&2; exit 1; }

# echo "Deleting Azure account credentials"
# rm ${PUBLISHSETTINGS} || { echo "Failed, aborting." >&2; exit 1; }