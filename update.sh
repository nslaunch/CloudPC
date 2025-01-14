#!/bin/bash

# Log file for tracking
LOG_FILE="update_log.txt"

# Function to log output
log() {
  echo "$(date) - $1" | tee -a $LOG_FILE
}

# Check available disk space
log "Checking available disk space..."
df -h | tee -a $LOG_FILE

# Check available memory
log "Checking available memory..."
free -m | tee -a $LOG_FILE

# Clean up unnecessary packages
log "Cleaning up unnecessary packages..."
sudo apt autoremove --purge -y | tee -a $LOG_FILE
sudo apt clean | tee -a $LOG_FILE

# Update the system
log "Updating the system..."
sudo apt update && sudo apt upgrade -y | tee -a $LOG_FILE
sudo apt dist-upgrade -y | tee -a $LOG_FILE

# Install update-manager-core if it's not installed
log "Installing update-manager-core..."
sudo apt install update-manager-core -y | tee -a $LOG_FILE

# Ensure release-upgrades is set to prompt for LTS
log "Ensuring upgrade settings are correct..."
sudo sed -i 's/^Prompt=.*/Prompt=lts/' /etc/update-manager/release-upgrades

# Start the upgrade process
log "Initiating the upgrade process..."
sudo do-release-upgrade -d | tee -a $LOG_FILE

# If the upgrade fails or requires a manual confirmation, prompt user
if [[ $? -ne 0 ]]; then
  log "Upgrade failed or requires manual confirmation. Please check the log for details."
  exit 1
fi

# Reboot the system
log "Rebooting the system..."
sudo reboot
