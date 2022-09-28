#!/bin/bash

#
# Sets a "random" pin mode to test saving settings
#
# Usage:
#   openbk-tools/set_pin.sh IPADDRESS
# eg:
#   openbk-tools/set_pin.sh 192.168.123.234
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

IP=${1:-"192.168.4.1"}
ROOT_URL=http://$IP

await_device() {
    for (( ; ; )); do
        if curl -sI "$ROOT_URL" --connect-timeout 3 2>&1 | grep -w "200\|301\|302" ; then
            break
        fi
        sleep 2 && echo "... checking for $ROOT_URL ..."
    done
}

await_device

echo "Executing..."

# set wifi
curl -X GET http://$IP/lol/nope/api/reboot

echo "Done."
