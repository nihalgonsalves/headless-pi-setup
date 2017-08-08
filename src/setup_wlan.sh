#!/bin/bash

cat "$SETUP_DIR/pi_files/dhcpcd.conf.diff" >> "$PI_OS_MOUNT/etc/dhcpcd.conf"
cat "$SETUP_DIR/pi_files/wpa_supplicant.conf.diff" >> "$PI_OS_MOUNT/etc/wpa_supplicant/wpa_supplicant.conf"

echo "[headless-pi-setup] WiFi setup complete"
