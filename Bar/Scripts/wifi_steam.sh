#!/bin/bash

get_wifi_status() {
    # Check if connected
    SSID=$(nmcli -t -f active,ssid dev wifi | grep '^ja:' | cut -d: -f2)
    SIGNAL=$(nmcli -t -f active,signal dev wifi | grep '^ja:' | cut -d: -f2)

    if [ -z "$SSID" ]; then
        echo "disconnected 0"
    else
        echo "connected $SIGNAL"
    fi
}

# 1. Output the initial state right away
get_wifi_status

# 2. Monitor NetworkManager for active connection changes
# This blocks efficiently and only triggers a loop iteration on network events
nmcli monitor | while read -r line; do
    get_wifi_status
done
