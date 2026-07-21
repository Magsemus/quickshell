import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../../ColorSchemes"

Text {
    id: root

    property var parseData: function(data) { return data }
    property string procCommand: ""

    property int value: 0
    property int value2: 0
    property int value3: 0
        
    color: theme.colCyan
    font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
    renderType: Text.NativeRendering

    function update()
    {
        diagProc.running = true
    }

    Process {
        id: diagProc
        command: ["sh", "-c", procCommand]
        stdout: SplitParser {
            onRead: data => {
                root.value = root.parseData(data)
            }
        }
        Component.onCompleted: running = true
    }
}
