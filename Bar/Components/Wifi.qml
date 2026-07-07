import QtQuick
import Quickshell
import Quickshell.Io

Item
{
    width: wifi.width
    height: wifi.height

    ServiceButton { 
        id: wifi 
        labelText: "󰤯"
        onClickedAction: function () {
            console.log("GIGGITY WIFI!")
        }
        clickAble: false
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

                if (status == "disconnected") 
                {
                    wifi.labelText = "󰤮"
                }
                else
                {
                    if (strength > 80) wifi.labelText = "󰤨";      
                    else if (strength > 60) wifi.labelText = "󰤥"; 
                    else if (strength > 40) wifi.labelText = "󰤢"; 
                    else if (strength > 20) wifi.labelText = "󰤟";
                    else wifi.labelText = "󰤯"
                }
            }
        }
    }
}
