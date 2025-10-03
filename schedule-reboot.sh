#!/bin/bash
set -e

LOGFILE="/var/log/cron-reboot.log"
CRONCMD="/sbin/reboot >> $LOGFILE 2>&1"

# Function: Add cron job
add_cron() {
  read -p "Enter the reboot hour (0-23): " hour

  if ! [[ "$hour" =~ ^[0-9]+$ ]]; then
    echo "❌ Invalid input: must be a number."
    exit 1
  fi
  if [ "$hour" -lt 0 ] || [ "$hour" -gt 23 ]; then
    echo "❌ Invalid hour: must be between 0 and 23."
    exit 1
  fi

  CRONLINE="0 $hour * * * $CRONCMD"

  # Ensure log file exists
  touch "$LOGFILE"
  chmod 644 "$LOGFILE"

  # Remove any previous reboot cron job and add the new one
  crontab -l 2>/dev/null | grep -v -F "$CRONCMD" >/tmp/cron.tmp || true
  echo "$CRONLINE" >> /tmp/cron.tmp
  crontab /tmp/cron.tmp
  rm -f /tmp/cron.tmp

  echo "✅ Daily reboot scheduled at $hour:00."
  echo "📌 Logs will be written to: $LOGFILE"
}

# Function: Remove cron job
remove_cron() {
  crontab -l 2>/dev/null | grep -v -F "$CRONCMD" >/tmp/cron.tmp || true
  crontab /tmp/cron.tmp
  rm -f /tmp/cron.tmp
  echo "🗑️ Reboot cron job removed."
}

# Ensure root privileges
if [ "$EUID" -ne 0 ]; then
  echo "⚠️ This script must be run as root. Try again with:"
  echo "sudo $0"
  exit 1
fi

# Menu
while true; do
  echo "==============================="
  echo "   Daily Reboot Cron Manager   "
  echo "==============================="
  echo "1) Schedule daily reboot"
  echo "2) Remove reboot cron job"
  echo "3) Exit"
  read -p "Select an option [1-3]: " choice

  case $choice in
    1) add_cron ;;
    2) remove_cron ;;
    3) echo "Exiting."; exit 0 ;;
    *) echo "❌ Invalid option!" ;;
  esac
done
