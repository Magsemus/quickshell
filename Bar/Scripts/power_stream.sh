#!/bin/bash

get_profile() 
{
    if ! command -v powerprofilesctl &> /dev/null; then
        echo ""
        return
    fi

    local profile 
    profile=$(powerprofilesctl get 2>/dev/null)

    case "$profile" in
        "performance")  echo "" ;;
        "balanced")     echo "" ;;
        "power-saver")  echo "󰌪" ;;
        *)              echo "" ;;
    esac
}

get_profile

dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged',arg0='net.hadess.PowerProfiles'" 2>/dev/null | \
while read -r line; do
    if [[ "$line" == *"net.hadess.PowerProfiles"* ]]; then
        get_profile
    fi
done

