#!/bin/bash

#
# Flashes firmware using hid_download_py's uartprogrammer.
# Pauses serial_monitor.sh temporarily
# 
# For OpenBK7231_App
#
# Usage:
#   openbk-tools/flash_serial.sh PORTNAME PLATFORM
# eg:
#   openbk-tools/flash_serial.sh /dev/ttyUSB1 bk7231n
#
# Uses uartprogram from https://github.com/OpenBekenIOT/hid_download_py
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

DEVICE=${1:-"/dev/ttyUSB1"}
PLATFORM=${2:-"x"}
PLATFORM=${PLATFORM,,}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILENAME=$SCRIPT_DIR/../platforms/${PLATFORM}/${PLATFORM}_os/tools/generate/Open${PLATFORM^^}_App_QIO_1.0.0.bin
#   n uartprogram -s 0x0 -u -w ../platforms/bk7231n/bk7231n_os/tools/generate/OpenBK7231N_App_QIO_1.0.0.bin -d /dev/ttyUSB0

TOOLNAME=$SCRIPT_DIR/../hid_download_py/uartprogram

FLASHOPT=
if [ $PLATFORM == "bk7231n" ]; then
    FLASHOPT="$FLASHOPT -s 0x0 -u" 
fi
if [ $PLATFORM == "bk7231t" ]; then
    FLASHOPT="$FLASHOPT -s 0x11000" 
fi

if [[ ! -e "$DEVICE" ]]; then
    echo "Port $DEVICE not found, aborting."
    exit 0
fi

if [[ ! -f "$FILENAME" ]]; then
    echo "$FILENAME not found. Aborting" && exit 0
fi

if [[ ! -f "$TOOLNAME" ]]; then
    echo "$TOOLNAME not found. Aborting" && exit 0
fi

USE_VENV=0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ -f "$SCRIPT_DIR/.venv/pyvenv.cfg" ]]; then
    echo "Activating venv ..."
    source $SCRIPT_DIR/.venv/bin/activate
    USE_VENV=1
fi

echo "Flashing $FILENAME to $DEVICE ..."
touch ${TMPDIR:-/tmp/}openbk-tools-pause.tmp
sleep 1
python $TOOLNAME $FLASHOPT -w "$FILENAME" -d "$DEVICE"
sleep 1
rm ${TMPDIR:-/tmp/}openbk-tools-pause.tmp

if [ $USE_VENV == "1" ]; then
    echo "Deactivating venv"
    deactivate
fi
