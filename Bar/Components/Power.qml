import QtQuick
import Quickshell
import Quickshell.Io

Item
{
    width: power.width
    height: power.height

    ServiceButton { 
        id: power 
        activeIcon: ""
        onClickedAction: function () {
            console.log("GIGGITY PERFORMANCE!")
        }
        clickAble: false
    }

    Process
    {
        id: powerProc

        command: ["/bin/bash", "/home/magse/.config/quickshell/Bar/Scripts/power_stream.sh"]
        running: true

        onRunningChanged: if(!running) running = true

        stdout: SplitParser {
            onRead: (line) => {
                let cleanLine = line.trim();
                power.updateIcon(cleanLine);
            }
        }
    }
}
