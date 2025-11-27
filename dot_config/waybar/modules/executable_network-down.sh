#!/bin/bash

# Get initial RX bytes
rx=$(cat /sys/class/net/[ew]*/statistics/rx_bytes 2>/dev/null | awk "{sum+=\$1} END {print sum}")

# Wait 1 second
sleep 1

# Get RX bytes after 1 second
rx2=$(cat /sys/class/net/[ew]*/statistics/rx_bytes 2>/dev/null | awk "{sum+=\$1} END {print sum}")

# Calculate and print download speed in megabits per second (Mbps)
# use decimal megabits (1 Mbps = 1_000_000 bits) which is standard for network speeds
if [ -z "$rx" ] || [ -z "$rx2" ]; then
	printf "0.0 Mb/s"
else
	# bytes -> bits (*)8 -> megabits (/1_000_000)
	awk "BEGIN {printf \"%.1f Mb/s\", (($rx2 - $rx) * 8) / 1000000}"
fi
