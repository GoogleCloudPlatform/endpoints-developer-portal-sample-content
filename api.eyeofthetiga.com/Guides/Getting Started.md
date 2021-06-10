# Getting Started

## Development Flow 

1. Setup your rasbperry as explained in the [secton below](https://github.com/Plantiga/endpoints-developer-portal/blob/srossross-patch-2/api.eyeofthetiga.com/Guides/Getting%20Started.md#setting-up-the-rasbperry-pi) This step is only required once
2. Before you want to connect the application, you must run the emulator on the pi [emulator](https://github.com/Plantiga/endpoints-developer-portal/blob/srossross-patch-2/api.eyeofthetiga.com/Guides/Getting%20Started.md#install-an-run-the-base-station-emulator)
3. To test that the emulator is working you can use a mobile tool like:
    * [LightBlue](https://punchthrough.com/lightblue/) for mobile
    * [BlueSee](https://www.synapse.com/bluesee) for mac desktop
4. You should be able to get and set the GATT characteristics as documented in our [API documentation](https://endpointsportal.plantiga-dev.cloud.goog/docs/api.eyeofthetiga.com/1/c/Guides/BaseStation)

## Seup Flow 

To complete a basestation setup you must perform the following steps with the BLE API:

### 1. WIFI SERVICE `0xD000`

1. Set the SSID Characteristic `0xD001`
2. Set the Password Characteristic `0xD002`
3. Set the Connect Characteristic `0xD004`
4. Check the status `0xD005` for `CONNECTED`

### 2. API SERVICE `0xD100`

1. Get the API key by exchanging a `firebase id token` with a `cloud-adapter-token` using our API [/cloud-gears/cloud-adapter-token](https://endpointsportal.plantiga-dev.cloud.goog/docs/api.eyeofthetiga.com/1/routes/cloud-gears/cloud-adapter-token/get)
1. Set the API key `0xD101` 
1. Check the API status `0xD102` for `KEY_OK`


## Setting up the Rasbperry PI 

The Base Station Emulator is intended to be run on a Raspberry Pi running the [Raspberry Pi OS Lite](https://www.raspberrypi.org/software/operating-systems/).

1. Download the OS zip, extract its image file, and use a tool like [Balena Etcher](https://www.balena.io/etcher/) to flash the image onto a microSD card. 
2. If you would like to configure the system via a USB Keyboard and HDMI, skip to `step 5`.
3. To enable ssh connectivity upon booting up the Pi, create an empty file named `ssh` in the root directory of the boot directory on the microSD card. This can be done with a command like `touch /Volumes/boot/ssh` if you are on a Mac and the `boot` directory is mounted in `/Volumes`.
4. To enable a wifi connection, you can create another file in the `boot` directory named `wpa_supplicant.conf` containing the following information:
    ```
   ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
   country=<Insert 2 letter ISO 3166-1 country code here>
   update_config=1
   network={
     ssid="<Name of your wireless LAN>"
     psk="<Password for your wireless LAN>"
    }
    ```
    Where the country code should be set the two letter ISO/IEC alpha2 code for the country in which you are using (e.g. US, DE, GB)
5. Plug in the microSD card to the Raspberry Pi and plug in the power, allowing up to 5 minutes for the Pi to boot for the first time. The default username is: `pi` and its password is: `raspberry`.
   1. If you are logging in via the tty using Keyboard and HDMI, use `wpa_cli` to configure the wifi, create the file from `step 4` in the location `/etc/wpa_supplicant/wpa_supplicant.conf` and reboot or restart the `wpa_supplicant.service`, or use an ethernet cable to connect to the internet.
   2. If you used `step 3` and `step 4` to set up your Pi, you can connect via ssh (if you are on the same network) using the hostname: `raspberrypi.local`.

## Install an run the Base Station Emulator

1. Download the latest version of the Emulator binary using the command 
   
   `wget https://storage.googleapis.com/plantiga-prod-downloads/SmartDockBLE/2021.05.12%2B85c69a0/plantiga-ble-emulator`

   and use `chmod +x plantiga-ble-emulator` to make it executable.
2. Disable the Linux bluetooth service with `sudo systemctl disable bluetooth.service` and ensure it is stopped, as that will interfere with the emulator. 
3. Run the emulator with root privileges `sudo ./plantiga-ble-emulator`  and proceed with development.
