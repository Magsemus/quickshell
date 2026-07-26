import Quickshell 
import QtQuick
import Quickshell.Io
import "./Components"
import "../../ColorSchemes"

Item
{
    width: wifiColumn.width + 30
    height: wifiColumn.height + 10

    Colorscheme { id: theme }

    Column {
        id: wifiColumn

        anchors.centerIn: parent
        spacing: 10

        Text {
            id: wifiName
            color: theme.colFg
            width: 156
            font { family: theme.fontFamily; pixelSize: 12; bold: true }
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        
        Rectangle
        {
            width: signalColumn.width + 20
            height: signalColumn.height + 10
            radius: 12

            color: theme.colLightBlue
            
            Column
            {
                id: signalColumn
                anchors.centerIn: parent
                spacing: 5

                Text {
                    id: signalTitle
                    color: theme.colFg
                    width: 156
                    font { family: theme.fontFamily; pixelSize: 11; bold: true }
                    renderType: Text.NativeRendering
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "󰀂 Signal level"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Row
                {
                    id: signalRow
                    spacing: 5

                    bottomPadding: 5

                    ProgressBar {
                        id: signalBar

                        width: 150
                        height: 25
                        color: theme.colWhite

                        innerRectColor: theme.colFg

                        maxValue: 70
                        value: 4

                        Text {
                            id: signalText
                            color: theme.colDarkBlue
                            width: 156
                            font { family: theme.fontFamily; pixelSize: 11; bold: true }
                            renderType: Text.NativeRendering
                            anchors.centerIn: parent

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Text {
                    id: qualityTitle
                    color: theme.colFg
                    width: 156
                    font { family: theme.fontFamily; pixelSize: 11; bold: true }
                    renderType: Text.NativeRendering
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "󰲝 Link quality"

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                Row
                {
                    id: qualityRow
                    spacing: 5

                    ProgressBar {
                        id: qualityBar

                        width: 150
                        height: 25
                        color: theme.colWhite

                        innerRectColor: theme.colFg

                        maxValue: 70
                        value: 4

                        Text {
                            id: qualityText
                            color: theme.colDarkBlue
                            width: 156
                            font { family: theme.fontFamily; pixelSize: 11; bold: true }
                            renderType: Text.NativeRendering
                            anchors.centerIn: parent

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    } 
                }
            }
        }
        SpeedOMeter { 
            id: reciever 
            progress: 0

            anchors.topMargin: 10
        }
    }

    Process {
        id: wifiShellCommand
        command: ["bash", "-c", "iw dev wlp0s20f0u3 link"]

        // 2. Capture standard output
        stdout: StdioCollector {
            id: stdoutCollector
        }

        onExited: (code, status) => {
            var stdoutList = stdoutCollector.text.trim().split("\n");

            let match = stdoutList[0].match(/\(on\s+([^)]+)\)/);
            let interfaceName = match ? match[1] : "";
            wifiName.text = stdoutList[1].replace("SSID: ", "").trim() + " | " + interfaceName;
            
            let signalNumber = stdoutList[5].match(/-?\d+/g);
            signalBar.value = signalBar.maxValue + (Number(signalNumber) + 30);
            signalText.text = signalNumber + " dbm";

            let RX = Number(stdoutList[6].match(/-?\d+/g)[0]) / 8;
            reciever.progress = reciever.speedToProgress(RX.toFixed(1))
            reciever.currentMeasurement.text = RX.toFixed(1)
        }
    }

    Process {
        id: linkQualityCommand
        command: ["bash", "-c", "grep wlp0s20f0u3 /proc/net/wireless | awk '{print int($3)}'"]

        // 2. Capture standard output
        stdout: SplitParser{
            onRead: (line) => {
                qualityBar.value = Number(line) 
                qualityText.text = line + "/70"
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            wifiShellCommand.running = true
            linkQualityCommand.running = true
        }
    }

    Component.onCompleted: {
        wifiShellCommand.running = true
        linkQualityCommand.running = true
    }
}
