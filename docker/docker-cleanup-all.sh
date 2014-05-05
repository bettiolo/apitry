#!/bin/bash

echo "Warning! Deleting ALL docker container and images"
read -p "Are you sure? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

docker rm $(docker ps --no-trunc -a -q)
docker rmi $(docker images -q)