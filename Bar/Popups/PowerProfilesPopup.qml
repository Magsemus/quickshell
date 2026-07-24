import Quickshell 
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import "../../ColorSchemes"
import "../Components/Base"

Item
{
    id: powerProfilesPopup

    width: column.width + 20
    height: column.height + 20

    anchors.centerIn: parent
    
    Colorscheme { id: theme }

    function switchToPerformance() {
        profileText.text = "Power profile: Performance"

        performance.textColor = theme.colCyan
        balanced.textColor = theme.colFg
        powerSaver.textColor = theme.colFg

        circle.x = performance.x + 7
    }

    function switchToBalanced() {
        profileText.text = "Power profile: Balanced"

        performance.textColor = theme.colFg
        balanced.textColor = theme.colCyan
        powerSaver.textColor = theme.colFg

        circle.x = balanced.x + 6.5
    }

    function switchToPowerSaver() {
        profileText.text = "Power profile: power-saver"

        performance.textColor = theme.colFg
        balanced.textColor = theme.colFg
        powerSaver.textColor = theme.colCyan

        circle.x = powerSaver.x + 7
    }

    Column
    {        
        id: column
        anchors.centerIn: parent
        spacing: 10
        
        Text
        {
            id: batteryText
            color: theme.colFg
            width: 156
            font { family: theme.fontFamily; pixelSize: 10; bold: true }
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

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

            width: selectionRow.width + 14
            height: selectionRow.height + 14
            radius: 24

            anchors.horizontalCenter: parent.horizontalCenter

            color: theme.colLightBlue

            property int sharedRadius: 27
                
            Shape {
                id: circle

                width: selectionRect.sharedRadius
                height: selectionRect.sharedRadius

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
                    activeIcon: ""
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "performance"]);
                        powerProfilesPopup.switchToPerformance();
                        console.log(performance.height + " : " + performance.width)
                    }
                    hoverAble: true
                    isCircle: true
                    buttonRadius: selectionRect.sharedRadius
                    width: 28
                    anchors.verticalCenter: parent.verticalCenter
                }

                ServiceButton {
                    id: balanced
                    activeIcon: ""
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "balanced"]);
                        powerProfilesPopup.switchToBalanced();
                        console.log(balanced.height + " : " + balanced.width)
                    }
                    hoverAble: true
                    isCircle: true
                    buttonRadius: selectionRect.sharedRadius
                    buttonRect.x: -0.5
                    width: 28
                    anchors.verticalCenter: parent.verticalCenter
                }

                ServiceButton {
                    id: powerSaver
                    activeIcon: "󰌪"
                    onClickedAction: function () {
                        Quickshell.execDetached(["powerprofilesctl", "set", "power-saver"]);
                        powerProfilesPopup.switchToPowerSaver();
                        console.log(powerSaver.buttonRadius)
                    }
                    hoverAble: true
                    isCircle: true
                    buttonRadius: selectionRect.sharedRadius
                    width: 28
                    anchors.verticalCenter: parent.verticalCenter
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
                        powerProfilesPopup.switchToPerformance();
                        break;
                    case "":
                        powerProfilesPopup.switchToBalanced();
                        break;
                    case "󰌪":
                        powerProfilesPopup.switchToPowerSaver();
                        break;
                    default: 
                        profileText.text = "Power profile: unknown";
                        break;

                }
            }
        }
    }

    Process {
        id: batteryCheck
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/present 2>/dev/null || echo 'No battery'"]

        // 2. Capture standard output
        stdout: StdioCollector {
            onStreamFinished: {
                let output = text.trim()

                if (output === "1") {
                    console.log("Battery connected!")
                } else {
                    batteryText.text = "No battery connected"
                }
            }
        }
    }

    Component.onCompleted: batteryCheck.running = true
}
