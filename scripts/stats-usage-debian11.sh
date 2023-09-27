#!/bin/bash

# This script monitors CPU and memory usage.
# Thanks to stackoverflow.com and linuxconfig.org

#
# Crontab: */10 * * * * /path/machine-usage.sh
#

#
# Vars
#

# rdebug config
wDebugBin="../builds/rdebug-server" # rdebug binary path
wDebugHost="192.168.1.110" # rdebug host address
wDebugPort="8765" # rdebug host port

# Basic vars
wFlow="log"
wContext="usage"
wApp="script"
wFile="192.168.1.202"

# Devices to check disk space
devnames="/var"

#
# Processes
#

# Get the current usage of CPU and memory
cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')
memUsage=$(free -m | awk '/Mem/{print $3}')

$wDebugBin -cmd -flow=$wFlow -context="cpu" -topic="cpu" -value="$cpuUsage" -app=$wApp -filename=$wFile -line=23 -host=$wDebugHost -port=$wDebugPort

$wDebugBin -cmd -flow=$wFlow -context="memory_mb" -topic="memory_mb" -value="$memUsage" -app=$wApp -filename=$wFile -line=27 -host=$wDebugHost -port=$wDebugPort

# Disk usage
for devname in $devnames
do
    
    let p=`df -Pk $devname | grep -v ^File | awk '{printf ("%i", $5) }'`
    $wDebugBin -cmd -flow=$wFlow -context="disk_%_"$devname -topic="disk_%" -value="$p" -app=$wApp -filename=$wFile -line=38 -host=$wDebugHost -port=$wDebugPort
    
done

# Sleep for 1 second
sleep 1