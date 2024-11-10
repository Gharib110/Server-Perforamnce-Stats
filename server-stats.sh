#!/bin/bash

# Check if sysstat (SAR) is installed
if ! command -v sar &> /dev/null; then
    echo "sysstat is not installed. Please install it to use this script."
    exit 1
fi

# Total CPU Usage
echo "Total CPU Usage:"
sar 1 1 | grep "Average.*all" | awk '{print "CPU Load: "100 - $8"%"}'

# Total Memory Usage
echo -e "\nTotal Memory Usage (Free vs Used including percentage):"
total_mem=$(free -m | awk '/Mem:/ {print $2}')
used_mem=$(free -m | awk '/Mem:/ {print $3}')
free_mem=$(free -m | awk '/Mem:/ {print $4}')
used_mem_percentage=$((used_mem * 100 / total_mem))
echo "Total: ${total_mem}MB, Used: ${used_mem}MB ($used_mem_percentage%), Free: ${free_mem}MB"

# Total Disk Usage
echo -e "\nTotal Disk Usage (Free vs Used including percentage):"
df -h --total | grep 'total' | awk '{print "Total: "$2", Used: "$3", Free: "$4", Usage: "$5}'

# Top 5 Processes by CPU Usage
echo -e "\nTop 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

# Top 5 Processes by Memory Usage
echo -e "\nTop 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6

# Stretch Goals
echo -e "\nAdditional Information:"

# OS Version
echo -e "\nOS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f 2

# Uptime
echo -e "\nSystem Uptime:"
uptime -p

# Load Average
echo -e "\nLoad Average (Last 1, 5, 15 minutes):"
uptime | awk -F'load average:' '{print $2}'

# Logged In Users
echo -e "\nLogged In Users:"
who

# Failed Login Attempts
echo -e "\nFailed Login Attempts:"
grep "Failed password" /var/log/auth.log | wc -l
