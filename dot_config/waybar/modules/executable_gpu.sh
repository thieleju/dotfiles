#!/bin/bash

# Get GPU temperature
temp=$(sensors 2>/dev/null | grep -i edge | awk "{print \$2}" | tr -d "+°C" | cut -d. -f1 | head -1)

# Get GPU usage
usage=$(cat /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1)

# Return JSON with conditional class
if [ $temp -gt 80 ]; then
    echo "{\"text\":\"$usage%  $temp°C\",\"class\":\"critical\"}"
else
    echo "{\"text\":\"$usage%  $temp°C\",\"class\":\"normal\"}"
fi
