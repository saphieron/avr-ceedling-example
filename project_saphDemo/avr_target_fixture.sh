#!/bin/sh

FileToFlash="$1"
UartPort="$2"
TargetDevice="$3"

/usr/bin/avrdude "-D" "-p$TargetDevice" "-cwiring" "-P$UartPort" "-Uflash:w:$FileToFlash:a"