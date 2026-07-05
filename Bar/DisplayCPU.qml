import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"

Text {
    text: "CPU: " + cpuUsage + "%"
    color: theme.colYellow
    font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }

    Colorscheme { id: theme}

    property var lastCpuTotal
    property var lastCpuIdle
    property var cpuUsage: 0

    function updateCpu() {
        cpuProc.running = true
    }

    Process {
        id: cpuProc

        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var p = data.trim().split(/\s+/)
                var idle = parseInt(p[4]) + parseInt(p[5])
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
                if (lastCpuTotal > 0) {
                    cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
                }
                lastCpuTotal = total
                lastCpuIdle = idle
            }
        }
        Component.onCompleted: running = true
    }

    Text {

    }
}
