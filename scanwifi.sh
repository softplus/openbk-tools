#!/bin/bash

#
# Continuously shows wifi APs in range
#
# Usage:
#   openbk-tools/scanwifi.sh
#
# MIT License / (C) johnmu / https://github.com/softplus/openbk-tools
# 

# clear window, go to top; save postion on top
clear
echo -en "\033[s"
echo "Checking AP's ..."

for (( ; ; )); do
  # return to top
  echo -en "\033[u"

  # show wifi ap's
  nmcli dev wifi

  # some empty lines & status
  echo -en "\033[K\n\033[K\n\033[K"
  echo "Updating in 3 seconds"
  echo -en "\033[K\n\033[K\n\033[K"
  sleep 3

  # work forever, no retirement ever
done

