# openbk-tools

Clone into a directory within your main OpenBK firmware.
Made & tested in Ubuntu 20.X, YMMV.
Automatically activates/deactivates .venv where Python is used.

Made for https://github.com/openshwprojects/OpenBK7231T_App

Tested with BK7231N, BK7231T chips. 

[MIT License](LICENSE) / (c) John Mueller

## Setup

For BK7231N:

```bash
mkdir whateverdir && cd whateverdir
git clone https://github.com/openshwprojects/OpenBK7231N .
chmod +x *.sh
git clone https://github.com/openshwprojects/OpenBK7231T_App apps/OpenBK7231N_App
git clone https://github.com/OpenBekenIOT/hid_download_py
git clone https://github.com/softplus/openbk-tools

# setup python stuff
cd openbk-tools
chmod +x *.sh
# setup virtualenv -- recommended
virtualenv .venv && source .venv/bin/activate
pip install -r requirements.txt
deactivate
cd ..
```

For BK7231N / personal repos:

```bash
mkdir whateverdir && cd whateverdir
git clone https://github.com/softplus/tuya-iotos-embeded-sdk-wifi-ble-bk7231n . -b branch_sdk
chmod +x *.sh
git clone https://github.com/softplus/OpenBK7231T_App apps/OpenBK7231N_App -b branch_app
git clone https://github.com/OpenBekenIOT/hid_download_py
git clone https://github.com/softplus/openbk-tools -b branch_too

# setup python stuff
cd openbk-tools
chmod +x *.sh
# setup virtualenv -- recommended
virtualenv .venv && source .venv/bin/activate
pip install -r requirements.txt
deactivate
cd ..
# done
```

# Tools

## Wifi-level tools

## wifi_logs - monitor logs via wifi, port 9000

Tries to connect to device via port 9000, requests logs.
Saves a local version of the logs to your /tmp-dir. 

```bash
wifi_logs.sh IPADDRESS
# eg:  openbk-tools/wifi_logs.sh 192.168.4.1
```

### ota - upload firmware via wifi

Uploads the current firmware via wifi.
Reboots the device afterwards and checks for availability.

Expects firmware at: SCRIPT_DIR/../platforms/{PLATFORM}/{PLATFORM}_os/tools/generate/Open{PLATFORM^^}_App_1.0.0.rbl

```bash
ota.sh IPADDRESS PLATFORM
# Eg:  openbk-tools/ota.sh 192.168.4.1 bk7231n
```

### scanwifi - shows open access-points

Nothing fancy, just easier than manually. 
Updates automatically in the terminal window.
Runs `nmcli dev wifi`.

```bash
openbk-tools/scanwifi.sh
```

## Serial port tools

### serial_monitor - monitor serial port for logs

Retries serial port automatically.
Pauses when uploading firmware with flash_serial.sh.

```bash
serial_monitor.sh PORTNAME
# eg:  openbk-tools/serial_monitor.sh /dev/ttyUSB1
```

### flash_serial - upload firmware via serial

Uploads the current firmware to the device with the serial port.
Watches out for starting memory address.

Expects firmware at: SCRIPT_DIR/../platforms/{PLATFORM}/{PLATFORM}_os/tools/generate/Open{PLATFORM^^}_App_QIO_1.0.0.bin


```bash
flash_serial.sh PORTNAME PLATFORM
# Eg:  openbk-tools/flash_serial.sh /dev/ttyUSB1 bk7231n
```

## Change settings / make actions

### set_reboot - reboot device

Sends reboot request to REST API. Device should reboot in 3 seconds.

```bash
set_reboot.sh IPADDRESS
# eg: openbk-tools/set_reboot.sh 192.168.4.1
```

### set_wifi - set WIFI AP & password

Sets the device WIFI accesspoint & password.
Can use the `_SECRETS.sh` file to make it easier for you to set.
Create your own `_SECRETS.sh` file by copying `_SECRETS_EXAMPLE.sh`.

```bash
set_wifi.sh IPADDRESS APNAME PASSWORD
# eg: openbk-tools/set_wifi.sh 192.168.4.1 "My-AP" "12345"
#  or openbk-tools/set_wifi.sh 192.168.4.1 # use settings file
```
