import Quickshell 
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import "../../ColorSchemes"
import "../Components/Base"

Item
{
    width: column.width + 20
    height: column.height + 20

    anchors.centerIn: parent
    
    Colorscheme { id: theme }

    Column
    {        
        id: column
        anchors.centerIn: parent
        spacing: 10
        
        Text
        {
            id: profileText
            color: theme.colFg
            width: 156
            font { family: theme.fontFamily; pixelSize: 10; bold: true }
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            id: selectionRect

            width: selectionRow.width + 10
            height: selectionRow.height + 10
            radius: 24

            anchors.horizontalCenter: parent.horizontalCenter

            color: theme.colLightBlue
                
            Shape {
                id: circle

                width: selectionRow.height + 6
                height: selectionRow.height + 6

                x: 42

                anchors.verticalCenter: parent.verticalCenter
                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeWidth: 0
                    fillColor: theme.colDarkBlue

                    startX: 0
                    startY: 0

                    PathAngleArc {
                        centerX: circle.width/2; centerY: circle.height/2
                        radiusX: circle.width/2; radiusY: circle.height/2
                        startAngle: 0
                        sweepAngle: 360
                    }
                }
                Behavior on x{
                    NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                }
            }

            Row {
                id: selectionRow

                anchors.centerIn: parent
                spacing: 7

                ServiceButton {
                    id: performance
                    activeIcon: "\u200A\u2001"
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "performance"])
                        console.log(performance.x)
                    }
                    hoverAble: false
                    width: 28
                }

                ServiceButton {
                    id: balanced
                    activeIcon: ""
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "balanced"])
                        console.log(balanced.x)
                    }
                    hoverAble: false
                    width: 28
                }

                ServiceButton {
                    id: powerSaver
                    activeIcon: "󰌪"
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "power-saver"])
                    }
                    hoverAble: false
                    width: 28
                }
            }
        }
    }

    Process
    {
        id: scriptProc

        command: ["/bin/bash", "/home/magse/.config/quickshell/Bar/Scripts/power_stream.sh"]
        running: true

        onRunningChanged: if(!running) running = true

        stdout: SplitParser {
            onRead: (line) => {
                switch (line) {
                    case "":
                        profileText.text = "Power profile: Performance"

                        performance.textColor = theme.colCyan
                        balanced.textColor = theme.colFg
                        powerSaver.textColor = theme.colFg
                    
                        circle.x = performance.x + 8
                        break
                    case "":
                        profileText.text = "Power profile: Balanced"

                        performance.textColor = theme.colFg
                        balanced.textColor = theme.colCyan
                        powerSaver.textColor = theme.colFg

                        circle.x = balanced.x + 5
                        break
                    case "󰌪":
                        profileText.text = "Power profile: power-saver"

                        performance.textColor = theme.colFg
                        balanced.textColor = theme.colFg
                        powerSaver.textColor = theme.colCyan
                
                        circle.x = powerSaver.x + 5 
                        break
                    default: 
                        profileText.text = "Power profile: unknown"
                        break

                }
            }
        }
    }
}
