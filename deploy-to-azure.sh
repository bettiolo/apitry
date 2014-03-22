#!/bin/bash

: ${1?"Usage: $0 <path-to-publishsettings>"}

PUBLISHSETTINGS=`pwd`/$1
echo ${PUBLISHSETTINGS}

echo "Installing Windows Azure command line tools"
npm install azure-cli --global || { echo "Failed, aborting." ; exit 1; }

echo "Importing Windows Azure account credentials: ${PUBLISHSETTINGS}"
azure account import ${PUBLISHSETTINGS} || { echo "Failed, aborting." ; exit 1; }

# echo "Creating default deployment script for node"
# azure site deploymentscript --node || { echo "Failed, aborting." ; exit 1; }

CREATED=`date -u +"%Y-%m-%dT%H-%M-%SZ"`
echo "Creating virtual machine: oauth-console-${CREATED}"
azure site create oauth-console-${CREATED} --location "West Europe" --gitusername deploy || { echo "Failed, aborting." ; exit 1; }

echo "Git pushing to azure origin"
git push azure master || { echo "Failed, aborting." ; exit 1; }

echo "Clearing imported Windows Azure account"
azure account clear || { echo "Failed, aborting." ; exit 1; }

# echo "Deleting Windows Azure account credentials"
