# schedule-reboot

A small bash script to schedule daily server reboot (hour only) or remove the reboot cron job.

## Features

- Prompt for hour (0–23) to set daily reboot at that hour (minute = 00)  
- Remove the reboot cron job  
- Logs reboot output to `/var/log/cron-reboot.log`  

## Usage

### One-liner install & run (quick method)

```bash
curl -sL https://raw.githubusercontent.com/tdk121212/schedule-reboot/main/schedule-reboot.sh | sudo bash
