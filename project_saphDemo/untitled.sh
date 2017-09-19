#!/bin/bash

DEBUG="YES"

if [ $DEBUG == "YES" ]; then
	echo "debug is yes"
fi

DEBUG="NO"

if [ $DEBUG != "YES" ]; then
	echo "debug is ungleich yes"
fi