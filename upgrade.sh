#!/usr/bin/env bash

#---------------------------------------------------------------------------------------------
# Copyright (c) IBODigital GmbH. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
#---------------------------------------------------------------------------------------------

#
# Bash script to install on-premise trustkey
#

echo
echo "======================================================="
echo
echo "This script will install Trustkey on your Raspberry Pi"
echo
echo "======================================================="

#
# Prompt the user for the trustkey version number to install
#
while :; do
	read -ep 'Enter trustkey version (number only): ' number
    	[[ $number =~ ^[[:digit:]]+$ ]] || continue
    	(( ( (number=(10#$number)) <= 9999 ) && number >= 0 )) || continue
    	# Here I'm sure that number is a valid number in the range 0..9999
    	# So let's break the infinite loop!
    	break
done

#
# Get the trustkey docker container
#
image=$(docker ps -aqf "name=trustkey-premise-pi")

if [[ -n "$image" ]]
then
	echo "Removing trustkey docker image "$image
	docker rm -f $image
else
	echo "No containers to remove"
fi

#
# Pull the docker image
#
echo "Fetching trustkey docker container version "$number
docker system prune --all --force
docker pull ibodigital/trustkey-premise-pi:v$number

#
# Once we have it, start the container
#
echo "Starting container..."

docker run --env-file env_trustkey.conf --name trustkey-premise-pi -p 80:8080 -p 8081:8081 --restart on-failure:5 -d ibodigital/trustkey-premise-pi:v$number

echo "trustkey docker container is now running"
echo "check the status using:"
echo
echo "docker ps -a"
echo
echo "Finsihed."
