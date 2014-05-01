#! /bin/bash

if [ ! -f /home/vagrant/already-installed-flag ]
then
   : ${1?"Usage: $0 <node-port>"}
   NODE_PORT=${1}

	echo "Installing..."

   echo "Changing to /home/vagrant"
   cd /home/vagrant
   echo "Setting ENV variables to .bash_profile"
   echo "export port=${NODE_PORT}" >> .bash_profile

   echo "Cloning oauth-console"
   git clone https://github.com/bettiolo/oauth-console.git
   echo "Changing top ./oauth-console"
   cd ./oauth-console/src
   echo "Installing npm dependencies"
   npm install

   echo "Setting already-installed-flag"
   touch /home/vagrant/already-installed-flag

   echo "Finished installing!"
else
   echo "Already installed (flag: /home/vagrant/already-installed-flag)"
fi