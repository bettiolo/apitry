#! /bin/bash

if [ ! -f /home/vagrant/already-installed-flag ]
then

	echo "Provisioning..."

	echo "Updating packages"
	pacman -Syu --noconfirm
	echo "Installing NodeJs and NPM"
	pacman -S nodejs --noconfirm
	echo "Updating NPM"
	npm update -g npm
	echo "Updating glbal NPM packages"
	npm update -g
	echo "Installing git"
	pacman -S git --noconfirm

	echo "Finished provisioning!"
else
	echo "Already installed (flag: /home/vagrant/already-installed-flag)"
fi