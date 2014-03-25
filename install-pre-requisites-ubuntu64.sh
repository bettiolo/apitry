#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

echo "Installing VirtualBox"
sudo apt-get install virtualbox || die

echo "Changing to vagrant/"
cd vagrant || die

echo "Downloading Vagrant"
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.5.1_x86_64.deb || die

echo "Insalling Vagrant"
sudo dpkg -i vagrant_1.5.1_x86_64.deb || die

echo "Cleaning up Vagrant installation files"
rm vagrant_1.5.1_x86_64.deb || die

echo "Changing to ../"
cd .. || die

echo "Creating packer/ folder"
mkdir packer || die

echo "Changing to packer/"
cd packer || die

echo "Downloading Packer"
wget https://dl.bintray.com/mitchellh/packer/0.5.2_linux_amd64.zip || die

echo "Extracting Packer"
unzip 0.5.2_linux_amd64.zip || die

echo "Cleaning Up Packer installation files"
rm 0.5.2_linux_amd64.zip || die