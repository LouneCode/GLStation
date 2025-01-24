#!/bin/sh

echo "Start scanning for GLStations ..."
cat /proc/net/arp | xargs -I {} echo {}| awk '{print $1}' | xargs -I {} ping -w1 -c 1 {} 2> /dev/null | grep "1 received" -B1| grep -A1 '^--$' | grep -v '^--$'| awk '{print $2}' | xargs -I {} nc -zv -W1 {} 2210 2>&1 | grep succeeded

read -r -p "Press any key to continue..." key