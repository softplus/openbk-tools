#!/bin/bash

#
# Read logs from OpenBK device, infinitely
# Keep a local copy for debugging.
#
# For OpenBK7231_App
#
# Usage:
#   openbk-tools/wifi_logs.sh IPADDRESS
# eg:
#   openbk-tools/wifi_logs.sh 192.168.123.234
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

IP=${1:-"192.168.4.1"}
ROOT_URL=http://$IP

LOGFILE=${TMPDIR:-/tmp/}log_$(echo "$IP" | sed 's/\./_/g').txt
echo "Logging to $LOGFILE..."

ADD_DATE=(awk -W interactive '{ print "[", strftime(), "]", $0; fflush(); }')

# kill any previous instances to avoid missing entries
PID=`ps -eaf | grep "nc $IP" | grep -v grep | awk '{print $2}'`
if [[ "" !=  "$PID" ]]; then
  echo "Killing $PID" | tee >("${ADD_DATE[@]}" >>$LOGFILE)
  kill -9 $PID
fi

await_device() {
    for (( ; ; )); do
        if curl -sI "$ROOT_URL" --connect-timeout 3 2>&1 | grep -w "200\|301\|302" ; then
            break
        fi
        sleep 2 && echo "... checking for $ROOT_URL ..."
    done
}

for (( ; ; )); do
  await_device
  echo "Reconnecting to $IP ..." | tee >("${ADD_DATE[@]}" >>$LOGFILE)

  # netcat from IP, port 9000
  nc $IP 9000 -w 10 2>&1 | tee >("${ADD_DATE[@]}" >>$LOGFILE)

  sleep 2

  # die on this hill, erhm, loop
done
