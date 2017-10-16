# avr-ceedling-example
A small test example of how to actually realise a double test environment of local testing with the default ceedling settings and target testing on the device itself, in this case for Atmel chips. This repo provides two ceedling configuration files for local and target testing, a support library to pipe the test results via UART back to the user and a helper script, currently written in python, to call the upload program avrdude and listen to the UART results. 
For personal reasons this is wrapped with a small gradle configuration, to be able to include this into larger projects and for easy exchange of the ceedling configuration files, as well as the recompilation of the support library for different Atmel platforms.

### Tested/developed with:

* Ceedling:: 0.28.1
	* CException:: 1.3.1.18
	* CMock:: 2.4.4.215
	* Unity:: 2.4.1.120
* Gradle:: 4.2
* Python:: 2.7.12
* Ubuntu 16.04 (Linux Mint 18.1)


### Things to consider when getting started
Currently there are 2 (actually 3) configuration files that need to be checked, set when using this toolchain: The Gradle config file "gradle.build" and the 2 ceedling files configuration_files/local.yml and configuration_files/local.yml. local.yml does not need to be changed as nearly all of its settings have been copied from the default ceedling settings. When trying to run tests on the target however you need to adapt the device description, e.g. 'atmega328p' or 'atmega2560' in both the gradle.build and the target.yml files. In future versions gradle should update the target.yml automatically so you only need to set that information in one file. 

To set up the target compiler, i.e. avr-gcc, according to your OS you can do so in the target.yml. Consider checking https://github.com/ThrowTheSwitch/Ceedling/blob/master/docs/CeedlingPacket.md for a much more detailed explanation.
