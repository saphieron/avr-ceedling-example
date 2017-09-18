#!/bin/bash

VAR=$1

echo "$VAR"

FILENAME=${VAR%.elf}.hex

echo "$FILENAME"