#!/bin/bash

pi_script_dir="$PI_OS_MOUNT/home/pi/headless"
mkdir -p $pi_script_dir

# Copy config script
cp "$SETUP_DIR/pi_files/btserial.sh" "$pi_script_dir/btserial.sh"
chmod +x "$pi_script_dir/btserial.sh"

# Copy autostart script
cp "$PI_OS_MOUNT/etc/rc.local" "$PI_OS_MOUNT/etc/rc.local.backup"
cp "$SETUP_DIR/pi_files/rc.local" "$PI_OS_MOUNT/etc/rc.local"

# Copy 'security' script
cp "$SETUP_DIR/pi_files/btsecure.sh" "$pi_script_dir/btsecure.sh"

echo "[headless-pi-setup] Bluetooth setup complete"
