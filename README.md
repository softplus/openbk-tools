# openbk-tools

Clone into a directory within your main OpenBK firmware. 

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
# eg:  wifi_logs.sh 192.168.4.1
```

### ota - upload firmware via wifi

Uploads the current firmware via wifi.
Reboots the device afterwards and checks for availability.

```bash
ota.sh IPADDRESS PLATFORM
# Eg:  ota.sh 192.168.4.1 bk7231n
```

### scanwifi - shows open access points, connects as needed

Nothing fancy, just easier than manually. 
Updates automatically in the terminal window.
Runs `nmcli dev wifi`.

```bash
scanwifi.sh
```

## Serial port tools
### serial_monitor - monitor serial port for logs

Retries serial port automatically.
Pauses when uploading firmware with flash_serial.sh.

```bash
serial_monitor.sh PORTNAME
# eg:  serial_monitor.sh /dev/ttyUSB1
```

### flash_serial - upload firmware via serial

Uploads the current firmware to the device with the serial port.
Watches out for starting memory address.

```bash
flash_serial.sh PORTNAME PLATFORM
# Eg:  flash_serial.sh /dev/ttyUSB1 bk7231n
```
