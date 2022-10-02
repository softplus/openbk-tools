#!/bin/bash

#
# Reads the full flash with hid_download_py's uartprogrammer.
# 
# For OpenBK7231_App
#
# Usage:
#   openbk-tools/read_flash.sh PORTNAME PLATFORM
# eg:
#   openbk-tools/read_flash.sh /dev/ttyUSB1 bk7231n
#
# Uses uartprogram from https://github.com/OpenBekenIOT/hid_download_py
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

DEVICE=${1:-"/dev/ttyUSB1"}
PLATFORM=${2:-"x"}
PLATFORM=${PLATFORM,,}
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#   uartprogram -s 0x0 -u -w ../platforms/bk7231n/bk7231n_os/tools/generate/OpenBK7231N_App_QIO_1.0.0.bin -d /dev/ttyUSB0

TOOLNAME=$SCRIPT_DIR/../hid_download_py/uartprogram

if [[ ! -e "$DEVICE" ]]; then
    echo "Port $DEVICE not found, aborting."
    exit 0
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

echo "Reading sections of flash, you may need to reset the device to trigger read ..."
touch ${TMPDIR:-/tmp/}openbk-tools-pause.tmp
sleep 1

# default to full 2MB, except bk7231t
STARTADDR=0x0
LENADDR=0x1FFFFF
if [ $PLATFORM == "bk7231t" ]; then
    STARTADDR=0x10000
    LENADDR=0x1EFFFF
fi
#../hid_download_py/uartprogram -d /dev/ttyUSB0 -s 0x0 -l 0x11000 -r ../bk7231n_boot.bin
python $TOOLNAME -d "$DEVICE" -s $STARTADDR -l $LENADDR -r "${PLATFORM}_data.bin"

echo "Splitting into partitions"
OPTIF="if=${PLATFORM}_full.bin"
OPTFL="iflag=skip_bytes,count_bytes"
#dd if=input.binary of=output.binary skip=$offset count=$bytes iflag=skip_bytes,count_bytes
if [ $PLATFORM == "bk7231n" ]; then
    # source: https://github.com/tuya/tuya-iotos-embeded-sdk-wifi-ble-bk7231t/blob/5e28e1f9a1a9d88425f3fd4b658e895a8ee7b83b/platforms/bk7231t/bk7231t_os/beken378/func/user_driver/BkDriverFlash.c
    mv ${PLATFORM}_data.bin ${PLATFORM}_full.bin
    dd $OPTIF of=${PLATFORM}_boot.bin skip=$((0x0))      count=$((0x011000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_app.bin  skip=$((0x011000)) count=$((0x121000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_ota.bin  skip=$((0x12A000)) count=$((0x0A6000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_rf.bin   skip=$((0x1D0000)) count=$((0x001000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_net.bin  skip=$((0x1D1000)) count=$((0x001000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_rest.bin skip=$((0x1D2000)) count=$((0x02DFFF)) $OPTFL
fi
if [ $PLATFORM == "bk7231t" ]; then
    # https://github.com/openshwprojects/OpenBK7231T/blob/master/platforms/bk7231t/bk7231t_os/beken378/func/user_driver/BkDriverFlash.c
    # bk7231t can't request first 0x10000 bytes from flash
    dd if=/dev/zero of=${PLATFORM}_zero.bin count=$((0x10000)) $OPTFL
    cat ${PLATFORM}_zero.bin ${PLATFORM}_data.bin >${PLATFORM}_full.bin
    rm  ${PLATFORM}_zero.bin
    dd $OPTIF of=${PLATFORM}_boot.bin skip=$((0x0))      count=$((0x011000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_app.bin  skip=$((0x011000)) count=$((0x121000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_ota.bin  skip=$((0x132000)) count=$((0x096000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_rf.bin   skip=$((0x1E0000)) count=$((0x001000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_net.bin  skip=$((0x1E1000)) count=$((0x001000)) $OPTFL
    dd $OPTIF of=${PLATFORM}_rest.bin skip=$((0x1E2000)) count=$((0x01DFFF)) $OPTFL
fi

echo "Done."

sleep 1
rm ${TMPDIR:-/tmp/}openbk-tools-pause.tmp

if [ $USE_VENV == "1" ]; then
    echo "Deactivating venv"
    deactivate
fi
