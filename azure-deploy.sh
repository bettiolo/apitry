#!/bin/sh

[ "$#" -eq 2 ] || { echo "Usage: ${0} <path-to-publishsettings> <git-deploy-username>" >&2; exit 1; }

PUBLISHSETTINGS=`pwd`/${1}
GITUSER=${2}

echo "Installing Azure command line tools"
npm install azure-cli --global || { echo "Failed, aborting." >&2; exit 1; }

echo "Importing Azure account credentials: ${PUBLISHSETTINGS}"
azure account import ${PUBLISHSETTINGS} || { echo "Failed, aborting." >&2; exit 1; }

CREATED=`date -u +"%Y-%m-%dT%H-%M-%SZ"`
echo "Creating Azure site: oauth-console-${CREATED}"
azure site create oauth-console-${CREATED} --location "West Europe" --git --gitusername ${GITUSER} || { echo "Failed, aborting." >&2; exit 1; }

echo "Pushing to 'azure' remote"
git push azure master || { echo "Failed, aborting." >&2; exit 1; }

echo "Deleting 'azure' remote"
git remote remove azure || { echo "Failed, aborting." >&2; exit 1; }

echo "Clearing imported Azure account"
azure account clear || { echo "Failed, aborting." >&2; exit 1; }

# echo "Deleting Azure account credentials"
# rm ${PUBLISHSETTINGS} || { echo "Failed, aborting." >&2; exit 1; }