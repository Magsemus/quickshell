pragma Singleton

import QtQuick
import Quickshell
import "Icons.js" as IconData

QtObject
{
    property var iconMap: IconData.icons

    function getTrayIcon(id, icon = ""): string
    {
        let lowerId = id ? id.toLowerCase() : "";
        let lowerIcon = icon ? icon.toLowerCase() : "";

        // 1. Point directly to the Flatpak exported full-color SVG assets
        for (let key in iconMap)
        {
            if (lowerId.includes(key) || lowerIcon.includes(key))
            {
                return iconMap[key];
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
        else return getArchIcon();
    }

    function getArchIcon() : string
    {
        return iconMap["arch"]
    }

    function getAppIcon(appId) {
        if (!appId || appId === "") {
            return iconMap["arch"]; 
        }

        let cleanId = appId.toLowerCase();

        if (cleanId === "steam")
        {
            let steamIcon = getTrayIcon(cleanId)

            if (steamIcon != getArchIcon()) return steamIcon
        }

        // Quickshell.iconPath(name, check) -> setting 'true' returns an empty string 
        // instead of a broken/missing texture if the app icon doesn't exist in the theme
        let entry = DesktopEntries.heuristicLookup(cleanId);
        if (entry && entry.icon) {
            return Quickshell.iconPath(entry.icon);
        }

        // If the system theme doesn't have an icon matching the app ID, fallback to Arch
        return iconMap["arch"];
    }
}
