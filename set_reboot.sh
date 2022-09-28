#!/bin/bash

#
# Reboots device via wifi
#
# Usage:
#   openbk-tools/set_reboot.sh IPADDRESS
# eg:
#   openbk-tools/set_reboot.sh 192.168.123.234
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

# use API to trigger reboot, could also use GET request
curl -X POST http://$IP/api/reboot

echo "Done."
