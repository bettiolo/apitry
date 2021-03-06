#!/bin/bash

SITE_PREFIX=oauthconsole
HELP="Usage: $0 [-f] <path-to-publishsettings>"
FORCE=0
AZURE_CLI_PRESENT=0
AZURE_REMOTE_ADDED=0
AZURE_SITE_CREATE_FAILED=0

[ "$#" -ge 1 ] || { echo $HELP >&2; exit 1; }
if [ "$1" = "-f" ]
then
	FORCE=1
	PUBLISHSETTINGS=$2
else
	PUBLISHSETTINGS=$1
fi

if [ ! "${PUBLISHSETTINGS:0:1}" = "/" ]
then
	PUBLISHSETTINGS=$(pwd)/$PUBLISHSETTINGS
fi

if command -v azure >/dev/null 2>&1
then
	AZURE_CLI_PRESENT=1
fi

cleanup () {
    if [ $AZURE_CLI_PRESENT -eq 1 ]
   	then

		if [ $AZURE_SITE_CREATE_FAILED -eq 1 ]
		then
			echo "Deleting the Azure site that failed to create: $SITE_NAME_NOT_RUNNING"
			azure site delete -q $SITE_NAME_NOT_RUNNING
		fi

    	echo "Clearing imported Azure account"
    	azure account clear -q
    fi

    if [ $AZURE_REMOTE_ADDED -eq 1 ]
   	then
   		echo "Removing 'azure' remote"
		git remote remove azure
	fi

	# echo "Deleting Azure account credentials"
	# rm $PUBLISHSETTINGS || die
}

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    cleanup
    exit 1
}

if [ $AZURE_CLI_PRESENT -eq 0 ]
then
	echo "Installing Azure command line tools"
	npm install azure-cli --global || die
else
	echo "Updating Azure command line tools"
	npm update azure-cli --global || die
fi

AZURE_CLI_PRESENT=1

echo "Importing Azure account credentials: $PUBLISHSETTINGS"
azure account import $PUBLISHSETTINGS || die

echo "Listing Azure sites"
SITES=$(azure site list) || die

SITE_NAME_GREEN=$SITE_PREFIX-GREEN
SITE_NAME_BLUE=$SITE_PREFIX-BLUE
INSTANCES_RUNNING=0

if echo "$SITES" | grep -Eq "^data:\s+$SITE_NAME_GREEN\s+.*Running"
then
	echo "GREEN instance running"
	SITE_NAME_RUNNING=$SITE_NAME_GREEN
	INSTANCES_RUNNING=$[$INSTANCES_RUNNING + 1]
else
	echo "GREEN instance NOT running"
	SITE_NAME_NOT_RUNNING=$SITE_NAME_GREEN
fi

if echo "$SITES" | grep -Eq "data:\s+$SITE_NAME_BLUE\s+.*Running"
then
	echo "BLUE instance running"
	SITE_NAME_RUNNING=$SITE_NAME_BLUE
	INSTANCES_RUNNING=$[$INSTANCES_RUNNING + 1]
else
	echo "BLUE instance NOT running"
	SITE_NAME_NOT_RUNNING=$SITE_NAME_BLUE
fi

if [ $INSTANCES_RUNNING -eq 0 ]
then
	echo "No instance running, default to GREEN"
	SITE_NAME_NOT_RUNNING=$SITE_NAME_GREEN
	SITE_NAME_RUNNING=$SITE_NAME_BLUE
fi

if [ $INSTANCES_RUNNING -eq 2 ]
then
	if [ $FORCE -eq 1 ]
	then
		echo "Forcing deploy to GREEN"
		SITE_NAME_NOT_RUNNING=$SITE_NAME_GREEN
		SITE_NAME_RUNNING=$SITE_NAME_BLUE
	else
		echo "Too many instances running, at least one should not be running"
		die
	fi
fi

echo "Instance running: $SITE_NAME_RUNNING"
echo "Instance NOT running: $SITE_NAME_NOT_RUNNING"

if echo "$SITES" | grep -Eq "data:\s+$SITE_NAME_NOT_RUNNING\s+.*Stopped"
then
	echo "Deleting non running Azure site: $SITE_NAME_NOT_RUNNING"
	azure site delete -q $SITE_NAME_NOT_RUNNING || die
fi

AZURE_SITE_CREATE_FAILED=1

echo "Creating Azure site: $SITE_NAME_NOT_RUNNING"
azure site create --location "West Europe" --git $SITE_NAME_NOT_RUNNING || die

AZURE_REMOTE_ADDED=1

echo "Disabling PHP"
azure site set --php-version off $SITE_NAME_NOT_RUNNING || die

# echo "Enabling Web Sockets"
# azure site set -w $SITE_NAME_NOT_RUNNING || die

echo "Getting Azure site data"
SITE_DATA=$(azure site show -d $SITE_NAME_NOT_RUNNING) || die
SITE_USERNAME=$(echo "$SITE_DATA" | grep -Eo "Config publishingUserName .+$" | cut -d " " -f 3)
SITE_PASSWORD=$(echo "$SITE_DATA" | grep -Eo "Config publishingPassword .+$" | cut -d " " -f 3)

echo "Publishing Username: $SITE_USERNAME"
echo "Publishing Password: [...]"

REMOTE_URL="https://$SITE_USERNAME:$SITE_PASSWORD@$(git ls-remote --get-url azure | cut -d @ -f 2)"
echo "Changing 'azure' remote url to: $REMOTE_URL" | sed "s/$SITE_PASSWORD/[...]/g" 
git remote set-url azure "$REMOTE_URL" || die

echo "Setting Azure environment variables"
azure site appsetting add APITRY_ENV=$(./get-env.sh) $SITE_NAME_NOT_RUNNING || die

echo "Pushing to 'azure' remote"
GIT_PUSH_OUTPUT=$(git push azure master 2>&1) || die
echo "$GIT_PUSH_OUTPUT" | sed "s/$SITE_PASSWORD/[...]/g"

AZURE_SITE_CREATE_FAILED=0

echo "Listing Azure sites"
SITES=$(azure site list) || die

if echo "$SITES" | grep -Eq "data:\s+$SITE_NAME_RUNNING\s+.*Running"
then
	echo "Stopping old running Azure site: $SITE_NAME_RUNNING"
	azure site stop $SITE_NAME_RUNNING || die
fi

cleanup

echo "Successfully deployed $SITE_NAME_NOT_RUNNING"