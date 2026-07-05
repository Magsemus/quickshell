import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick // for Text
import QtQuick.Layouts
import "../ColorSchemes"

Scope {

    Colorscheme { id: theme}

    PanelWindow {
        anchors {
            top: true
            left: true
            right: true
        }
        implicitHeight: 30
        color: theme.colBg
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 8

            Workspaces {}
            
            Item { Layout.fillWidth: true}
        }
        
        DisplayCPU { id: cpu }
        
        RowLayout {
            anchors.centerIn: parent
            anchors.margins: 8

            Text {
                text: "CPU: " + cpu.cpuUsage + "%"
                color: theme.colYellow
                font { family: theme.fontFamily; pixelSize: theme.fontSize; bold: true }
            }
        }

        Timer {
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                cpu.updateCpu()
            }
        }
    }
}
