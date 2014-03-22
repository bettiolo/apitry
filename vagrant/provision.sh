#! /bin/bash

if [ ! -f /home/vagrant/already-installed-flag ]
then
   : ${1?"Usage: $0 <node-port>"}
   NODE_PORT=${1}

   echo "Updating packages"
   pacman -Syu
   echo "Installing NodeJs and NPM"
   pacman -S nodejs --noconfirm
   echo "Updating NPM"
   npm update -g npm
   echo "Updating glbal NPM packages"
   npm update -g
   echo "Installing git"
   pacman -S git --noconfirm

   echo "Changing to /home/vagrant"
   cd /home/vagrant
   echo "Setting ENV variables to .bash_profile"
   echo "export port=${NODE_PORT}" >> .bash_profile

   echo "Cloning oauth-console"
   git clone https://github.com/bettiolo/oauth-console.git
   echo "Changing top ./oauth-console"
   cd ./oauth-console
   echo "Installing npm dependencies"
   npm install
   
   echo "Setting already-installed-flag"
   touch /home/vagrant/already-installed-flag
   
   echo "Done!"
else
   echo "Already installed (flag: /home/vagrant/already-installed-flag)"
fi