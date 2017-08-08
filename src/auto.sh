command=$1

echo "[headless-pi-setup] Auto-configuring $command"

./mount.sh

if [[ "$command" = "eth" ]]; then
  ./setup_ssh.sh
elif [[ "$command" = "bt" ]]; then
  ./setup_bt.sh
elif [[ "$command" = "wlan" ]]; then
  ./setup_ssh.sh
  ./setup_wlan.sh
elif [[ "$command" = "all" ]]; then
  ./setup_ssh.sh
  ./setup_wlan.sh
  ./setup_bt.sh
elif [[ "$command" = "ssh" ]]; then
  ./setup_ssh.sh
else
  echo "Unknown setup command"
  exit 1
fi

./umount.sh

echo "[headless-pi-setup] Auto-configuration done!"
