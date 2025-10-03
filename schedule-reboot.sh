#!/bin/bash

while true; do
    clear
    echo "==============================="
    echo "   Daily Reboot Cron Manager"
    echo "==============================="
    echo "1) Schedule daily reboot"
    echo "2) Remove reboot cron job"
    echo "3) Exit"
    echo -n "Choose an option: "
    read -r choice < /dev/tty   # <--- اینجا تغییر دادیم تا همیشه از ترمینال ورودی بگیره

    case $choice in
        1)
            echo -n "Enter reboot hour (0-23): "
            read -r hour < /dev/tty
            (crontab -l 2>/dev/null | grep -v "@reboot") | crontab -
            (crontab -l 2>/dev/null; echo "0 $hour * * * /sbin/reboot") | crontab -
            echo "Reboot scheduled daily at $hour:00"
            ;;
        2)
            crontab -l 2>/dev/null | grep -v "reboot" | crontab -
            echo "Reboot cron job removed."
            ;;
        3)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option."
            ;;
    esac

    echo
    echo "Press Enter to continue..."
    read -r dummy < /dev/tty
done
