#!/bin/bash
: ${1?"Usage: $0 path-to-publishsettings"}

echo "Installing Windows Azure command line tools"
npm install azure-cli --global

echo "Importing Windows Azure account credentials: $1"
azure account import $1

echo "Creating default deployment script for node"
azure site deploymentscript --node

CREATED=`date -u +"%Y-%m-%dT%H-%M-%SZ"`
echo "Creating virtual machine: oauth-console-$CREATED"
azure site create oauth-console-$CREATED --location "West Europe" --gitusername deploy

echo "Git pushing to azure origin"
git push azure master

echo "Clearing imported Windows Azure account"
azure account clear

echo "Deleting Windows Azure account credentials"