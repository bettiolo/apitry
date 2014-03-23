#!/bin/bash

echo "Changing to vagrant/"
cd vagrant/ || { echo "Failed, aborting." >&2 ; exit 1; }
echo "Taking vagrant up"
vagrant up || { echo "Failed, aborting." >&2 ; exit 1; }
echo "SSH into vagrant"
vagrant ssh || { echo "Failed, aborting." >&2 ; exit 1; }
