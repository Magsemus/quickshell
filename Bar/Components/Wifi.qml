import QtQuick
import Quickshell
import Quickshell.Io

Item
{
    width: wifi.width
    height: wifi.height

    ServiceButton { 
        id: wifi 
        activeIcon: "󰤯"
        onClickedAction: function () {
            console.log("GIGGITY WIFI!")
        }
        clickAble: false
        animationType: "fade"
    }

    Process
    {
        id: wifiProc

        command: ["/bin/bash", "/home/magse/.config/quickshell/Bar/Scripts/wifi_steam.sh"]
        running: true

        onRunningChanged: if(!running) running = true

        stdout: SplitParser {
            onRead: (line) => {
                let cleanLine = line.trim();
                let parts = cleanLine.split(" ")

                let status = parts[0]
                let strength = parseInt(parts[1])
                
                let targetIcon = "󰤮";
                if (status != "disconnected") 
                {
                    if (strength > 80) targetIcon = "󰤨";      
                    else if (strength > 60) targetIcon = "󰤥"; 
                    else if (strength > 40) targetIcon = "󰤢"; 
                    else if (strength > 20) targetIcon = "󰤟";
                    else targetIcon = "󰤯"
                }
                wifi.updateIcon(targetIcon);
            }
        }
    }
}
