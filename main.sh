#!/bin/bash

# For Disk Usage
threshold=90

disk_usage=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)
if [ "$disk_usage" -ge "$threshold" ]; then
    echo "Warning: Disk usage on $(hostname) is $disk_usage%." | mail -s "Disk Usage Alert" user@example.com
else
    echo "Disk usage is below the threshold."
fi

# For High Cpu Load Avg

threshold=90

# Get the current CPU usage
cpu_usage=$(top -b -n 1 | grep "%Cpu(s)" | awk '{print $2}' | cut -d. -f1)

if [ "$cpu_usage" -gt "$threshold" ]; then
    echo "CPU usage is above $threshold% on $(hostname) at $(date)"
else
    echo "Cpu usage is Below the Threshold value"
fi


# For Attempting Invalid Root Login
max_attempts=2
root_attempts=$(grep -i "Failed password for root" /var/log/auth.log | wc -l)

if [ "$root_attempts" -ge "$max_attempts" ]; then
    echo "Multiple root login attempts detected on $(hostname) at $(date)" 

fi


# Any File Events Occurs

# directory_to_monitor="/home/sridhar"

# inotifywait -m -e modify,access,attrib,close_write,delete,move,create "$directory_to_monitor" |
#     while read -r directory_event; do
#         echo "Directory breached in $directory_to_monitor at $(date): $directory_event" 
#     done


# Wheh the System Existing the Memory Usage 
threshold=1000
# memory usage in MB
memory_usage=$(free -m | awk 'NR==2 {print $3}')

if [ "$memory_usage" -gt "$threshold" ]; then
    echo "High memory usage detected on $(hostname) at $(date). Memory used: ${memory_usage}MB"
fi


# Check memory usage
memory_threshold=90
memory_usage=$(free | awk '/Mem:/ {print $3/$2 * 100}' | cut -d. -f1)

if [ "$memory_usage" -gt "$memory_threshold" ]; then
    echo "High Memory Usage Alert" "Memory usage is above $memory_threshold% on $(hostname) at $(date)."
fi

