#!/bin/bash

if [ $# -ne 1 ]; then
	echo "you need to provide private key";
	exit 1
fi

key=`echo $1 | sed 's/[0-9a-fA-F]*//'`
if [ -n "$key" ];
then
	echo "provided key must be in hexadecimal format"
	exit 2
fi

curl -H "Accept: application/json" -H "Content-Type: application/json" -d "{'value':'$1'}" http://localhost:7890/account/unlock

