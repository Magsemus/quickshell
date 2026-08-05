#!/bin/bash

get_wifi_status() {
    # Combine SSID and SIGNAL query into a single nmcli call to halve DBus load
    local active_info
    active_info=$(nmcli -t -f active,ssid,signal dev wifi | grep -E '^(yes|ja):')

    if [ -z "$active_info" ]; then
        echo "disconnected 0"
    else
        local ssid signal
        ssid=$(echo "$active_info" | cut -d ':' -f 2)
        signal=$(echo "$active_info" | cut -d ':' -f 3)
        echo "connected ${signal:-0}"
    fi
}

# 1. Output initial state
get_wifi_status

# 2. Background polling loop for signal strength updates (Lightweight timer)
(
    last_strength=""
    while true; do
        sleep 5
        # Quick query for active signal strength only
        current_strength=$(nmcli -t -f active,signal dev wifi | grep -E '^(yes|ja):' | cut -d ':' -f 2)
        
        if [ "$current_strength" != "$last_strength" ] && [ -n "$current_strength" ]; then
            get_wifi_status
            last_strength="$current_strength"
        fi
    done
) &

# 3. Primary DBus listener running in FOREGROUND (Blocks main execution)
gdbus monitor --system --dest org.freedesktop.NetworkManager --object-path /org/freedesktop/NetworkManager | while read -r line; do
    if [[ "$line" == *"StateChanged"* ]] || [[ "$line" == *"PropertiesChanged"* ]]; then
        get_wifi_status
    fi
done
