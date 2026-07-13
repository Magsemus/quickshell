pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Scope
{
    property var iconMap: [
        "spotify",
        "steam"
    ]

    function getTrayIcon(id, icon = ""): string
    {
        let lowerId = id ? id.toLowerCase() : "";
        let lowerIcon = icon ? icon.toLowerCase() : "";

        // 1. Point directly to the Flatpak exported full-color SVG assets
        for (let i = 0 ; i < iconMap.length ; i++)
        {
            if (lowerId.includes(iconMap[i]) || lowerIcon.includes(iconMap[i]))
            {
                //console.log(iconMap[i]);
                return getAppIcon(iconMap[i]);
            }
        }

        // 2. Handle Caelestia's SNI path query parsing safely
        if (icon.includes("?path=")) {
            let parts = icon.split("?path=");
            let name = parts[0];
            let path = parts[1];
            let cleanName = name.substring(name.lastIndexOf("/") + 1);
            return "file://" + path + "/" + cleanName;
        }

        // 3. Fallback for native/standard apps (like Discord)
        if (icon != "") return icon;
        else return Quickshell.iconPath("application-x-executable")
    }

    function getArchIcon() : string
    {
        return "file:///home/magse/.config/quickshell/Bar/Utils/Files/icons8-arch-linux.svg"
    }

    function getAppIcon(appId) {
        
        if (!appId || appId.trim() === "") {
            return Quickshell.iconPath("window_new")
            //"file:///usr/share/icons/breeze-dark/apps/24/utilities-terminal.svg"
        }

        let cleanId = appId.toLowerCase();

        // Quickshell.iconPath(name, check) -> setting 'true' returns an empty string 
        // instead of a broken/missing texture if the app icon doesn't exist in the theme
        let entry = DesktopEntries.heuristicLookup(cleanId);
        if (entry && entry.icon) {
            return Quickshell.iconPath(entry.icon);
        }

        // If the system theme doesn't have an icon matching the app ID, fallback to Arch
        return Quickshell.iconPath("application-x-executable")
    }
}
