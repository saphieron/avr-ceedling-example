#!/usr/bin/env python
import sys
import io
import serial

argumentLength = len(sys.argv)
if argumentLength < 3:
	print 'not enough arguments. Usage: python uart_test_reader.py <SerialPort> <BaudRate>'
	sys.exit(0)

PORT = sys.argv[1]
BAUD = sys.argv[2]

ser = serial.Serial()
ser.port = ''+PORT
ser.baudrate = BAUD
ser.open()

while True:
	lineRead = ser.readline()
	if lineRead == "STOPSTOPSTOP\n":
		sys.exit(0)
	else:
		print lineRead