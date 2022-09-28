#!/bin/bash

#
# Sets wifi AP & Password on device
#
# Usage:
#   openbk-tools/set_wifi.sh IPADDRESS APNAME PASSWORD
# eg:
#   openbk-tools/set_wifi.sh 192.168.123.234 "Nice+AP" "12345"
#   (values must be URL-safe-encoded)
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

IP=${1:-"192.168.4.1"}
ROOT_URL=http://$IP
AP=${2:-"Fancy+AP"}
PASS=${3:-"12345"}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SECRETS_FILE="${SCRIPT_DIR}/_SECRETS.sh"
if [[ -f "$SECRETS_FILE" ]]; then
    echo "Reading $SECRETS_FILE"
    source "$SECRETS_FILE"
fi

await_device() {
    for (( ; ; )); do
        if curl -sI "$ROOT_URL" --connect-timeout 3 2>&1 | grep -w "200\|301\|302" ; then
            break
        fi
        sleep 2 && echo "... checking for $ROOT_URL ..."
    done
}

await_device

echo "Setting wifi..."

# set wifi
curl -X GET "$ROOT_URL/cfg_wifi_set?ssid=${AP}&pass=${PASS}"

echo
echo "Done."
