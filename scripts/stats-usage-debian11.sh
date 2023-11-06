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
wDebugHost="192.168.0.X" # rdebug host address
wDebugPort="8765" # rdebug host port

# Basic vars
wFlow="log"
wContext="usage"
wApp="script-stats-usage"
wFile="192.168.0.Y"

# Devices to check disk space
devnames="/var"

#
# Processes
#

# Get the current usage of CPU and memory
cpuUsage=$(top -bn1 | awk '/Cpu/ { print $2}')
memUsage=$(free -m | awk '/Mem/{print $3}')

$wDebugBin -cmd -host=$wDebugHost -port=$wDebugPort -flow=$wFlow -context="cpu" -topic="cpu" -value="$cpuUsage" -app=$wApp -filename=$wFile -line=23

$wDebugBin -cmd -host=$wDebugHost -port=$wDebugPort -flow=$wFlow -context="memory_mb" -topic="memory_mb" -value="$memUsage" -app=$wApp -filename=$wFile -line=27

# Disk usage
for devname in $devnames
do
    
    let p=`df -Pk $devname | grep -v ^File | awk '{printf ("%i", $5) }'`
    $wDebugBin -cmd -flow=$wFlow -context="disk_"$wFile"_%_"$devname -topic="disk_%" -value="$p" -app=$wApp -filename=$wFile -line=38 -host=$wDebugHost -port=$wDebugPort
    
done

# Sleep for 1 second
sleep 1