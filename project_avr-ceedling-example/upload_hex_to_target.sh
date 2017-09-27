#!/bin/bash

function usage()
{
    echo "Saphieron's upload script:"
    echo "##############################"
    echo "./upload_hex_to_target.sh"
    echo "\t small helper script that converts a .elf-file from the ceedling building process into hex and uploads it to to a target device via the provided port. Collects the result over the same port"
    echo "\t Expected parameters:"
    echo "\t -p={Target} - specify target device to program with avrdude"
    echo "\t -c={programmer} - way how avrdude programs device"
    echo "\t -D - Disable auto erase. please check avrdude. necessary for atmega2560"
    echo "\t -F={File to flash} - binary .elf file that is converted to hex and then uploaded"
    echo "\t -B={Baud rate} - UART speed, to listen to test results"
    echo "\t -U={programmer port} - Port over which avrdude will upload hex file"
    echo "\t -L={listener port} - port over which to listen to test results. Expects that result transmission via UART ends with the message 'STOPSTOPSTOP'"
}

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
                usage
                exit
                ;;
        -p)
                export TARGET=$VALUE
                ;;
        -c)
                export PROGRAMMER=$VALUE
                ;;
        -D)
                export DISABLE_AUTO_ERASE=YES
                ;;
        -F)
                export FILE_TO_FLASH=$VALUE
                ;;
        -B)
                export BAUD=$VALUE
                ;;
        -U)
                export UPLOAD_PORT=$VALUE
                ;;
        -L)
                export LISTEN_PORT=$VALUE
    esac
    shift
done

# echo "-p $TARGET"
# echo "-c $PROGRAMMER"
# echo "-D <$DISABLE_AUTO_ERASE>"
# echo "-F $FILE_TO_FLASH"
# echo "-B $BAUD"
# echo "-U $UPLOAD_PORT"
# echo "-L $LISTEN_PORT"
# echo ""
# echo ""

#avrdude arguments
args=()
if [ ! -z "$TARGET" ]; then
	args+=(-p"$TARGET")
fi

if [ ! -z "$PROGRAMMER" ]; then
	args+=(-c"$PROGRAMMER")
fi

if [ ! -z "$UPLOAD_PORT" ]; then
	args+=(-P"$UPLOAD_PORT")
fi

if [ ! -z "$DISABLE_AUTO_ERASE" ]; then
	args+=(-D)
fi

if [ ! -z "$FILE_TO_FLASH" ]; then
        FILENAME=${FILE_TO_FLASH%.elf}.hex
        avr-objcopy -R .eeprom -R .fuse -R .lock -R .signature -O ihex "$FILE_TO_FLASH" "$FILENAME"
	args+=(-Uflash:w:$FILENAME:a)
fi

##debug
if [ -z "$TARGET" ] || [ -z "$PROGRAMMER" ] || [ -z "$UPLOAD_PORT" ] || [ -z "$LISTEN_PORT" ] || [ -z "$FILE_TO_FLASH" ]; then
        echo "not enough options provided"
        exit 1
fi
# args+=(-q)
avrdude "${args[@]}"

echo "TestListener"
echo "##############"
python uart_test_reader.py "$LISTEN_PORT" "$BAUD"
