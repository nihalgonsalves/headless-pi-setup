# Headless Raspberry Pi 3 Setup on macOS

Bootstrap a headless Raspberry Pi 3 (without a keyboard, mouse, or monitor) using Docker on macOS.

This Docker image lets you manipulate the Raspbian `.img` image (which has an `ext4` partition unreadable by macOS) directly from Docker on macOS without having to run a Linux VM or use a Linux host.

The included bash scripts can automatically set up the configuration for Bluetooth, WiFi, and SSH, and correctly mount the Raspbian image's two partitions for manipulation.

There are many guides online that achieve the same goal, but unfortunately require you to run a Linux VM to modify the `ext4` partition.

I suggest the Bluetooth option as it is the most straightforward, and you can then setup WiFi directly on the Pi through the Bluetooth terminal. Getting the WiFi to bootstrap itself can be tricky, and hard to troubleshoot without a keyboard/mouse/monitor.

Inspiration :

- https://caffinc.github.io/2016/12/raspberry-pi-3-headless/
- https://hacks.mozilla.org/2017/02/headless-raspberry-pi-configuration-over-bluetooth/


## Quick-start

### Prerequisites

1. Download [Docker](https://www.docker.com/community-edition#/download)

2. Clone this repository
    
    ```sh
    git clone https://github.com/nihalgonsalves/headless-pi-setup.git
    ```

3. Grab an image of Raspbian
    
    - Desktop environment: https://downloads.raspberrypi.org/raspbian_latest
    - Lite terminal-only: https://downloads.raspberrypi.org/raspbian_lite_latest

    Save the resulting `.img` file (unzip first) somewhere, we will need to mount this later.

### Modify the configuration (for WiFi setup only)

Edit the `wpa_supplicant.conf.diff` and `dhcpcd.conf.diff` files in `src/pi_files`. Add your own network and configure the IP ranges, router and DNS correctly (you can leave the lines commented if you have a working DHCP setup)

### Build and run

```sh
# when inside this repo's root
docker build . -t headless-pi-setup

# absolute path to raspbian img from earlier
export IMAGE=/host/path/to/raspbian.img

# to customise, replace bt with: eth / wlan / all
docker run \
  --rm \
  --privileged \
  -v $IMAGE:/home/images/raspbian.img:consistent \
  headless-pi-setup bash -c './auto.sh bt'
```

You should see output similar to this:

```
[headless-pi-setup] Auto-configuring all
mount: /dev/loop0 mounted on /mnt/pi/boot.
mount: /dev/loop1 mounted on /mnt/pi/os.
[headless-pi-setup] Mounted
[headless-pi-setup] SSH enabled
[headless-pi-setup] WiFi setup complete
[headless-pi-setup] Bluetooth setup complete
[headless-pi-setup] Unmounted
[headless-pi-setup] Auto-configuration done!
```

Now simply burn the image file (for example with [Etcher](https://etcher.io)) to your microSD card and boot up your Raspberry Pi 3

### Run a bash terminal with the mounted files

If you want to manually run commands or inspect the `img`'s file system:

```sh
docker run \
  -it \
  --rm \
  --privileged \
  -v $IMAGE:/home/images/raspbian.img:consistent \
  headless-pi-setup

# once you're inside the container, mount the img:
./mount.sh

# don't forget to unmount and exit when done:
./umount.sh && exit
```

## Connecting

### Bluetooth

1. Boot up the Pi, wait a minute or two, and then restart it. This lets the Bluetooth config take effect.

2. Pair with it from your Mac

3. Find the serial device:

  ```sh
  ls /dev/cu.*
  ```

4. Connect

  ```sh
  screen /dev/cu.raspberrypi-SerialPort 115200
  ```

5. Stop other devices from pairing

  ```sh
  ./headless/btsecure.sh
  ```
  
  (You need to do this on each reboot).


### WiFi

If all went well, you should be able to ssh into the Pi:

```sh
ssh pi@raspberrypi.local # password is raspberry
```

(Try a static IP or a tool such as [Pi Finder](https://github.com/adafruit/Adafruit-Pi-Finder) if you cannot connect)

## Reverting changes

### Bluetooth

Simply delete the folder, and restore `rc.local`

```sh
sudo rm -fR /home/pi/headless/
sudo rm /etc/rc.local
sudo mv /etc/rc.local.backup /etc/rc.local
```

### WiFi

The WiFi bootstrapping simply adds network data to `/etc/wpa_supplicant/wpa_supplicant.conf` and `/etc/dhcpcd.conf`. You can update these files if you would like to remove any data.

### SSH

Delete the `ssh` file in the root of the boot volume on the SD card.
