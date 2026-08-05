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

gdbus monitor --system --dest net.hadess.PowerProfiles --object-path /net/hadess/PowerProfiles | while read -r line; do
    # Re-evaluate whenever ActiveProfile or properties update
    if [[ "$line" == *"PropertiesChanged"* ]] || [[ "$line" == *"ActiveProfile"* ]]; then
        get_profile
    fi
done

