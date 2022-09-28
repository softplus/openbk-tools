#!/bin/bash

#
# Initiates an OTA to the given IP address
# Reboots afterwards
# For OpenBK7231_App
#
# Usage:
#   openbk-tools/ota.sh IPADDRESS PLATFORM
# eg:
#   openbk-tools/ota.sh 192.168.123.234 bk7231n
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

IP=${1:-"192.168.4.1"}
PLATFORM=${2:-"bk7231n"}
PLATFORM=${PLATFORM,,}

ROOT_URL=http://$IP
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FILENAME=$SCRIPT_DIR/../platforms/${PLATFORM}/${PLATFORM}_os/tools/generate/Open${PLATFORM^^}_App_1.0.0.rbl

if [[ ! -f "$FILENAME" ]]; then
    echo "$FILENAME not found. Aborting" && exit 0
fi

echo "Found $FILENAME - awaiting $ROOT_URL ..."

await_device() {
    for (( ; ; )); do
        if curl -sI "$ROOT_URL" --connect-timeout 3 2>&1 | grep -w "200\|301\|302" ; then
            break
        fi
        sleep 2 && echo "... checking for $ROOT_URL ..."
    done
}

await_device

echo "Uploading OTA..."

curl --data-binary "@$FILENAME" "$ROOT_URL/api/ota"

echo && echo "OTA uploaded, rebooting"

# catch my breath
sleep 10 

# reboot
curl -X POST $ROOT_URL/api/reboot

echo && echo "Reboot pending."
sleep 6 # 3 seconds to reboot, a few more to be connected

await_device

echo "Device is ready at $ROOT_URL"
