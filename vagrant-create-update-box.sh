#!/bin/sh

if [ ! -d "packer/" ]; then
	echo "Creating packer/ folder"
	mkdir packer/ || { echo "Failed, aborting." >&2 ; exit 1; }
fi
echo "Changing to packer/"
cd packer/ || { echo "Failed, aborting." >&2 ; exit 1; }
if [ ! -d "./packer-arch/" ]; then
	echo "Cloning packer-arch"
	git clone https://github.com/elasticdog/packer-arch.git || { echo "Failed, aborting." >&2 ; exit 1; }
fi
echo "Changing to packer-arch/"
cd packer-arch/ || { echo "Failed, aborting." >&2 ; exit 1; }
echo "Pulling packer-arch"
git pull || { echo "Failed, aborting." >&2 ; exit 1; }
echo "Building virtualbox from arch-template.json"
packer build -force -only=virtualbox-iso arch-template.json || { echo "Failed, aborting." >&2 ; exit 1; }
echo "Adding 'arch' vagrant box"
vagrant box add arch packer_arch_virtualbox.box --force || { echo "Failed, aborting." >&2 ; exit 1; }