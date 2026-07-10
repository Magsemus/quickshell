pragma Singleton

import QtQuick
import Quickshell
import "Icons.js" as IconData

Singleton 
{
    property var iconMap: IconData.icons

    function getTrayIcon(id: string, icon: string): string
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
        return icon;
    }

    function getArchIcon() : string
    {
        return iconMap["arch"]
    }
}
