# Raspberry Pi Utility Scripts

This directory contains a collection of Bash scripts designed to help manage and maintain your Raspberry Pi system. Below is a brief explanation of each script:

## rpi-keep-awake.sh
This script prevents your Raspberry Pi from going idle or sleeping due to inactivity. It periodically pings your router every 15 minutes and logs the result, ensuring the device stays awake and network-connected. It also logs the PIDs of running `sshd` processes for monitoring purposes.

## rpi-ram-cleaner.sh
A simple script to help free up system memory. It synchronizes data to disk, clears the page cache, dentries, and inodes, and displays memory usage before and after the cleanup. Useful for reclaiming RAM without rebooting.

## rpi-slim-raspbian.sh
This script generates commands to remove a large set of GUI and educational packages from a Raspbian installation. It is intended to help slim down your Raspberry Pi OS by purging unnecessary packages and running `apt-get autoremove` to clean up dependencies.

---

**Usage:**
- These scripts are intended to be run on a Raspberry Pi running a Linux-based OS (e.g., Raspbian).
- Make sure to give execute permission to the scripts before running:
  ```bash
  chmod +x scriptname.sh
  ```
- Run the scripts with appropriate privileges (some may require `sudo`).

**Note:**
- Review each script before running to ensure it fits your needs and environment.
