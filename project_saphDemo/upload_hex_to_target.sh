#!/bin/bash
#/usr/bin/avrdude -pm2560 -cwiring -P/dev/ttyACM2 -D -Uflash:w:AvrUnitySupportTester.hex:a

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "$package - some help message"
                        exit 0
                        ;;
                -p)
                        shift
                        if test $# -gt 0; then
                                export TARGET=$1
                        else
                                echo "no target specified"
                                exit 1
                        fi
                        shift
                        ;;
                -c*)
						shift
						if test $# -gt 0; then
                                export PROGRAMMER=$1
                        else
                                echo "no programmer specified"
                                exit 1
                        fi
                        shift
                        ;;
				-P*)
						shift
						if test $# -gt 0; then
                                export PORT=$1
                        else
                                echo "no PORT specified"
                                exit 1
                        fi
                        shift
                        ;;

                -D)
						export DISABLE_AUTO_ERASE=YES
						shift
						;;
                -U*)
						shift
						if test $# -gt 0; then
                                export FILE_TO_FLASH=$1
                        else
                                echo "no file to flash specified"
                                exit 1
                        fi
                        shift
                        ;;
                -B*)
						shift
						if test $# -gt 0; then
                                export BAUD=$1
                        else
                                echo "no BAUD rate specified"
                                exit 1
                        fi
                        shift
                        ;;

                *)
                        break
                        ;;
        esac
done

echo "options provided:"

args=()
if [ ! -z "$TARGET" ]; then
	args+=(-p"$TARGET")
	echo "$TARGET"
fi

if [ ! -z "$PROGRAMMER" ]; then
	args+=(-c"$PROGRAMMER")
	echo "$PROGRAMMER"
fi

if [ ! -z "$PORT" ]; then
	args+=(-P"$PORT")
	echo "$PORT"
fi

if [ ! -z "$DISABLE_AUTO_ERASE" ]; then
	args+=(-D)
	echo "-D"
fi

if [ ! -z "$FILE_TO_FLASH" ]; then
	args+=(-Uflash:w:"$FILE_TO_FLASH":a)
	echo "$FILE_TO_FLASH"
fi

echo "Arguments list:"
echo "${args[@]}"

echo "avrdude" "${args[@]}"
avrdude "${args[@]}"

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