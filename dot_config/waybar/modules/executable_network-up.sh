#!/bin/bash

# Get initial TX bytes
tx=$(cat /sys/class/net/[ew]*/statistics/tx_bytes 2>/dev/null | awk "{sum+=\$1} END {print sum}")

# Wait 1 second
sleep 1

# Get TX bytes after 1 second
tx2=$(cat /sys/class/net/[ew]*/statistics/tx_bytes 2>/dev/null | awk "{sum+=\$1} END {print sum}")

# Calculate and print upload speed in megabits per second (Mbps)
# use decimal megabits (1 Mbps = 1_000_000 bits) which is standard for network speeds
if [ -z "$tx" ] || [ -z "$tx2" ]; then
	printf "0.0 Mb/s"
else
	# bytes -> bits (*)8 -> megabits (/1_000_000)
	awk "BEGIN {printf \"%.1f Mb/s\", (($tx2 - $tx) * 8) / 1000000}"
fi
