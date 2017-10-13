# avr-ceedling-example
A small test example of how to actually realise a double test environment of local testing with the default ceedling settings and target testing on the device itself, in this case for Atmel chips. This repo provides two ceedling configuration files for local and target testing, a support library to pipe the test results via UART back to the user and a helper script, currently written in python, to call the upload program avrdude and listen to the UART results. 
For personal reasons this is wrapped with a small gradle configuration, to be able to include this into larger projects and for easy exchange of the ceedling configuration files, as well as the recompilation of the support library for different Atmel platforms.

##Tested/developed with:

*Ceedling:: 		0.28.1
	*CException:: 	1.3.1.18
	*CMock:: 		2.4.4.215
	*Unity:: 		2.4.1.120
*Gradle::		4.2
*Python:: 		2.7.12