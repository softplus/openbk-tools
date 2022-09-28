#!/bin/bash

#
# Tries to open the serial port, displays logs.
# Retries when port drops. Pauses for serial OTAs.
# Automatically uses venv, if it exists.
#
# For OpenBK7231_App
#
# Usage:
#   openbk-tools/serial_monitor.sh PORTNAME
# eg:
#   openbk-tools/serial_monitor.sh /dev/ttyUSB1
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

DEVICE=${1:-"/dev/ttyUSB1"}

if [[ ! -e "$DEVICE" ]]; then
    echo "Port $DEVICE not found, aborting."
    exit 0
fi

USE_VENV=0
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [[ -f "$SCRIPT_DIR/.venv/pyvenv.cfg" ]]; then
    echo "Activating venv ..."
    source $SCRIPT_DIR/.venv/bin/activate
    USE_VENV=1
fi

python $SCRIPT_DIR/serial_monitor.py -d $DEVICE
echo 

if [ $USE_VENV == "1" ]; then
    echo "Deactivating venv"
    deactivate
fi
