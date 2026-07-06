import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../ColorSchemes"

Text {
    text: "󰍛 " + mem.memUsage + "%"
    color: theme.colCyan
    font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
    renderType: Text.NativeRendering

    property int memUsage: 0

    function updateMem()
    {
        memProc.running = true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var total = parseInt(parts[1]) || 1
                var used = parseInt(parts[2]) || 0
                memUsage = Math.round(100 * used / total)
            }
        }
        Component.onCompleted: running = true
    }

}
