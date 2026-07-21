import QtQuick
import Quickshell
import Quickshell.Io

Item
{
    width: button.width
    height: button.height

    property var clickedAction: function() { console.log("No action assigned for the onClickedAction") }
    property var mouseHoverExit: function() {}
    property string scriptPath: ""
    property var procAction: function(line) { console.log("No action assigned for scriptProc") }
    property string textIcon: ""
    property string buttonAnimationType: "pop"

    function triggerIconUpdate(nextIcon) {
        button.updateIcon(nextIcon);
    }

    ServiceButton { 
        id: button
        activeIcon: textIcon
        onClickedAction: clickedAction
        clickAble: false
        onMouseHoverExit: mouseHoverExit
        animationType: buttonAnimationType
    }

    Process
    {
        id: scriptProc

        command: ["/bin/bash", scriptPath]
        running: true

        onRunningChanged: if(!running) running = true

        stdout: SplitParser {
            onRead: (line) => {
                procAction(line);
            }
        }
    }
}
