import Quickshell 
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import "../../ColorSchemes"
import "../Components/Base"

Item
{
    id: powerProfilesPopup

    width: column.width + 30
    height: column.height + 20

    anchors.centerIn: parent
    
    Colorscheme { id: theme }

    function switchProfile(profile) {
        profileText.text = `Power profile: ${profile}`

        performance.textColor = (profile == "performance") ? theme.colCyan : theme.colFg
        balanced.textColor = (profile == "balanced") ? theme.colCyan : theme.colFg
        powerSaver.textColor = (profile == "power-saver") ? theme.colCyan : theme.colFg

        switch(profile) {
            case "performance": circle.x = performance.x + 7; break
            case "balanced": circle.x = balanced.x + 6.5; break
            case "power-saver": circle.x = powerSaver.x + 7; break
        }
    }

    Column
    {        
        id: column
        anchors.centerIn: parent
        spacing: 10

        Rectangle
        {
            id: batteryRect
            implicitWidth: batteryText.width + 30
            implicitHeight: batteryText.height + 10
            color: theme.colLightBlue
            radius: 12

            Text
            {
                id: batteryText
                color: theme.colFg
                font { family: theme.fontFamily; pixelSize: 10; bold: true }
                renderType: Text.NativeRendering
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                verticalAlignment: Text.AlignVCenter
            }
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
                    fillColor: theme.colBlack

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
                        powerProfilesPopup.switchProfile("performance");
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
                        powerProfilesPopup.switchProfile("balanced");
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
                        powerProfilesPopup.switchProfile("power-saver");
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
                        powerProfilesPopup.switchProfile("performance");
                        break;
                    case "":
                        powerProfilesPopup.switchProfile("balanced");
                        break;
                    case "󰌪":
                        powerProfilesPopup.switchProfile("power-saver");
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
                    upowerCommand.running = true;
                    upowerTimer.running = true;
                } else {
                    batteryText.text = "No battery connected";
                }
            }
        }
    }

    Process {
        id: upowerCommand
        command: ["bash", "-c", "upower -i /org/freedesktop/UPower/devices/battery_BAT0"]

        stdout: StdioCollector {
            id: stdoutCollector
        }

        onExited: (code, status) => {
            let lines = stdoutCollector.text.trim().split("\n");
            if (lines.length < 2) return
            
            let stats = {};
            for (let i = 1; i < lines.length; i++) {
                let line = lines[i].trim();

                // Map line headers (e.g., "rx bytes: 123456") to stats key-value pairs
                let colonIdx = line.indexOf(":");
                if (colonIdx !== -1) {
                    let key = line.substring(0, colonIdx).trim();
                    let val = line.substring(colonIdx + 1).trim();
                    stats[key] = val;
                }
            }

            let hour = stats["time to empty"].match(/-?\d+(?:\.\d+)?/g)
            let timeLeft = `${hour[0]} h ${(Number("0." + hour[1]) * 60).toFixed(0)} min`

            batteryText.text = `energy-rate         ${String(stats["energy-rate"])}\nempty in            ${String(timeLeft)}\ncharge-cycles       ${String(stats["charge-cycles"])}\nbattery efficiency  ${stats["capacity"]}`;
        }
    }

    Timer {
        id: upowerTimer
        interval: 2000
        running: false
        repeat: true
        onTriggered: {
            upowerCommand.running = true
        }
    }

    Component.onCompleted: batteryCheck.running = true
}
