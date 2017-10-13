#!/usr/bin/env python
import sys
import io
import serial
import argparse
import os
from subprocess import call

parser = argparse.ArgumentParser()
parser.add_argument("-p", metavar='<Device>', help='specifies Atmel target device')
parser.add_argument("-c", metavar='<Programmer>', help='Avrdude programmer specification')
parser.add_argument("-F", metavar='<InputBinaryFile>', help='Binary to upload to target device')
parser.add_argument("-B", metavar='<BaudRate>', help='Avrdude programmer specification')
parser.add_argument("-U", metavar='<UploadPort>', help='serial port over which avrdude uploads InputBinaryFile, e.g., /dev/ttyACM1')
parser.add_argument("-L", metavar='<ListenPort>', help='serial port over which this script listens for test results. Can be same as UploadPort in cases like Arduino, e.g., /dev/ttyACM1')
parser.add_argument("-D", help='DISABLE_AUTO_ERASE option', action="store_true")

args = parser.parse_args()
TargetDevice = args.p
Programmer = args.c
InputBinaryFile = args.F
BaudRate = args.B
UploadPort = args.U
ListenPort = args.L
DisableAutoErase = args.D

 
if TargetDevice == None or Programmer == None or InputBinaryFile == None or BaudRate == None or UploadPort == None or ListenPort == None:
	if TargetDevice == None:
		print "Target device needs to be specified for avrdude. Check avrdude's list of devices"
	if Programmer == None:
		print "Programmer needs to be specified for avrdude. Check avrdude's list of programmers"
	if InputBinaryFile == None:
		print "No binary file provided"
	if BaudRate == None:
		print "No BaudRate provided"
	if UploadPort == None:
		print "No port for programming/uploading provided. Can be same as  ListenPort (e.g. with arduinos)"
	if ListenPort == None:
		print "No port for listening to test results via Uart provided. Can be same as ListenPort (e.g. with arduinos)"
	sys.exit(0)

#Call avr-objcopy to convert file to .hex
filename = os.path.splitext(InputBinaryFile)[0] + ".hex"
call(["avr-objcopy", "-R", ".eeprom", "-R", ".fuse", "-R", ".lock", "-R", ".signature", "-O", "ihex", InputBinaryFile, filename])

#Call avrdude to upload .hex file
if DisableAutoErase:
	call(["avrdude", "-p", TargetDevice, "-c", Programmer, "-P", UploadPort, "-D", "-Uflash:w:"+filename+":a"])
else:
	call(["avrdude", "-p", TargetDevice, "-c", Programmer, "-P", UploadPort, "-Uflash:w:"+filename+":a"])

ser = serial.Serial()
ser.port = ''+ ListenPort
ser.baudrate = BaudRate
ser.open()

while True:
	lineRead = ser.readline()
	if lineRead == "STOPSTOPSTOP\n":
		sys.exit(0)
	else:
		print lineRead
