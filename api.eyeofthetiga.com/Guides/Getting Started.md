# Getting Started
---

### Before you begin
1. Create a new [Cloud Platform project](https://console.developers.google.com/projectcreate).
2. [Enable billing](https://cloud.google.com/billing/docs/how-to/modify-project#enable_billing_for_a_project) for your project.

### Creating an API key
1. [Create an API key](https://console.developers.google.com/apis/credentials) in the Google APIs Console.
2. Click **Create credentials**, then select **API key**.
3. Copy the key to the clipboard.
4. Click **Close**.

### Enable the API

Before you can make calls to this API, you need to enable it in the Cloud Platform project you created.
1. [View this API](https://console.developers.google.com/apis/api/{{apiHost}}/overview) in the Google APIs Console.
2. Click the **Enable** button, then wait for it to complete.
3. You can now call the API using the API key you created!

### Using the API

Browse the reference section of this site to see examples of what you can do with this API and how to use it. You can use the **Try this API** tool on the right side of an API method page to generate a sample request.

### Setting up the Cloud Adapter Emulator


The Cloud Adapter Emulator is intended to be run on a Raspberry Pi running the [Raspberry Pi OS Lite](https://www.raspberrypi.org/software/operating-systems/).

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
6. Download the latest version of the Emulator binary using the command 
   
   `wget https://storage.googleapis.com/plantiga-prod-downloads/SmartDockBLE/2021.05.12%2B85c69a0/plantiga-ble-emulator`

   and use `chmod +x plantiga-ble-emulator` to make it executable.
7. Disable the Linux bluetooth service with `sudo systemctl disable bluetooth.service` and ensure it is stopped, as that will interfere with the emulator. 
8. Run the emulator with root privileges `sudo ./plantiga-ble-emulator`  and proceed with development.
