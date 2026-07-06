import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"

Text {
    text: " " + gpuTemp + "°C"
    color: theme.colCyan
    font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
    renderType: Text.NativeRendering

    property int gpuTemp: 0

    function updateGpu()
    {
        gpuProc.running = true
    }

    Process {
        id: gpuProc
        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                gpuTemp = data
            }
        }
        Component.onCompleted: running = true
    }

}
