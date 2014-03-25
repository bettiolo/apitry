#!/bin/bash

die () {
    local message=$1
    [ -z "$message" ] && message="Failed, aborting..."
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message" >&2
    exit 1
}

if [ ! -d "packer/" ]; then
	echo "Creating packer/ folder"
	mkdir packer/ || die
fi

echo "Changing to packer/"
cd packer/ || die

if [ ! -d "packer-arch/" ]; then
	echo "Cloning packer-arch"
	git clone https://github.com/elasticdog/packer-arch.git || die
fi

echo "Changing to packer-arch/"
cd packer-arch/ || die

if command -v ../packer >/dev/null 2>&1
then
	PACKER_CMD="../packer"
fi

if command -v packer >/dev/null 2>&1
then
	PACKER_CMD="packer"
fi

[[ -z "$PACKER_CMD" ]] && die "Packer not found"

echo "Pulling packer-arch"
git pull || die

echo "Building virtualbox from arch-template.json"
../packer build -force -only=virtualbox-iso arch-template.json || die

echo "Adding 'arch' vagrant box"
vagrant box add arch packer_arch_virtualbox.box --force || die
