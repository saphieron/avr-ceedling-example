#!/bin/bash

# while test $# -gt 0; do
#         case "$1" in
#                 -h|--help)
#                         echo "$package - some help message"
#                         exit 0
#                         ;;
#                 -p)
#                         shift
#                         if test $# -gt 0; then
#                                 export TARGET=$1
#                         else
#                                 echo "no target specified"
#                                 exit 1
#                         fi
#                         shift
#                         ;;
#                 -c*)
# 						shift
# 						if test $# -gt 0; then
#                                 export PROGRAMMER=$1
#                         else
#                                 echo "no programmer specified"
#                                 exit 1
#                         fi
#                         shift
#                         ;;
# 				-P*)
# 						shift
# 						if test $# -gt 0; then
#                                 export PORT=$1
#                         else
#                                 echo "no PORT specified"
#                                 exit 1
#                         fi
#                         shift
#                         ;;

#                 -D)
# 						export DISABLE_AUTO_ERASE=YES
# 						shift
# 						;;
#                 -U*)
# 						shift
# 						if test $# -gt 0; then
#                                 export FILE_TO_FLASH=$1
#                         else
#                                 echo "no file to flash specified"
#                                 exit 1
#                         fi
#                         shift
#                         ;;
#                 -B*)
# 						shift
# 						if test $# -gt 0; then
#                                 export BAUD=$1
#                         else
#                                 echo "no BAUD rate specified"
#                                 exit 1
#                         fi
#                         shift
#                         ;;

#                 *)
#                         break
#                         ;;
#         esac
# done

function usage()
{
    echo "if this was a real script you would see something useful here"
    echo ""
    echo "./simple_args_parsing.sh"
    echo "\t-h --help"
    echo "\t--environment=$ENVIRONMENT"
    echo "\t--db-path=$DB_PATH"
    echo ""
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
        -U)
                export FILE_TO_FLASH=$VALUE
                ;;
        -B)
                export BAUD=$VALUE
                ;;
        -P)
                export PORT=$VALUE
                ;;
    esac
    shift
done

echo "options provided:"

args=()
if [ ! -z "$TARGET" ]; then
	args+=(-p"$TARGET")
fi

if [ ! -z "$PROGRAMMER" ]; then
	args+=(-c"$PROGRAMMER")
fi

if [ ! -z "$PORT" ]; then
	args+=(-P"$PORT")
fi

if [ ! -z "$DISABLE_AUTO_ERASE" ]; then
	args+=(-D)
fi

if [ ! -z "$FILE_TO_FLASH" ]; then
        FILENAME=${FILE_TO_FLASH%.elf}.hex
        avr-objcopy -R .eeprom -R .fuse -R .lock -R .signature -O ihex "$FILE_TO_FLASH" "$FILENAME"
	args+=(-Uflash:w:$FILENAME:a)
fi

echo "Arguments list:"
echo "${args[@]}"

if [ -z "$TARGET" ] || [ -z "$PROGRAMMER" ] || [ -z "$PORT" ] || [ -z "$FILE_TO_FLASH" ]; then
        echo "not enough options provided"
        exit 1
fi



echo "executing: avrdude ${args[@]}"
echo ""

avrdude "${args[@]}"

echo ""
echo ""

echo "executing: python uart_test_reader.py "$PORT" "$BAUD""
echo ""
echo ""
python uart_test_reader.py "$PORT" "$BAUD"


# for i in "$@"
# do
# case $i in
#     -p=*)
#     TARGET="${i#*=}"
#     echo 'Target'
#     shift # past argument
#     ;;
#     -c=*)
#     PROGRAMMER="${i#*=}"
#     shift # past argument
#     ;;
#     -D)
#     DISABLE_AUTO_ERASE=YES
#     shift # past argument
#     ;;    
#     -P=*)
#     PORT="${i#*=}"
#     shift # past argument
#     ;;
# 	-U=*)
# 	FILE_TO_FLASH="${i#*=}"
# 	;;
#     *)
#         echo "que?"
#     ;;
# esac
# done

# args=()

# if [ DISABLE_AUTO_ERASE = YES ]
# then 
# 	: args+='-D'
# else
# 	:
# fi
# args+=("-p $TARGET")
# args+=("-c$PROGRAMMER")
# args+=("-P$PORT")
# args+=("-Uflash:w:$FILE_TO_FLASH:a")

# echo "${args[@]}"