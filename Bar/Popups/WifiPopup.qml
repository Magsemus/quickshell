import Quickshell 
import QtQuick
import Quickshell.Io

Item
{
    width: wifiColumn.width + 30
    height: wifiColumn.height + 10

    Column {
        id: wifiColumn

        anchors.centerIn: parent

        Text {
            id: wifiName
            color: theme.colFg
            width: 156
            font { family: theme.fontFamily; pixelSize: 11; bold: true }
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
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
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            wifiShellCommand.running = true
        }
    }

    Component.onCompleted: wifiShellCommand.running = true
}
