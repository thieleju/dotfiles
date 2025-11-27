#!/bin/bash

# Get CPU usage
usage=$(top -bn2 -d 0.1 | grep "Cpu(s)" | tail -1 | awk "{print \$2}" | cut -d"," -f1)

# Get CPU temperature
temp=$(cat /sys/class/hwmon/hwmon2/temp1_input)
temp_c=$(awk "BEGIN {printf \"%.0f\", $temp/1000}")

# Return JSON with conditional class
if [ $temp_c -gt 80 ]; then
    echo "{\"text\":\"$usage%  $temp_c°C\",\"class\":\"critical\"}"
else
    echo "{\"text\":\"$usage%  $temp_c°C\",\"class\":\"normal\"}"
fi
