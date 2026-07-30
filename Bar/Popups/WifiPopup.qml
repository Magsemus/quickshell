import Quickshell 
import QtQuick
import Quickshell.Io
import Quickshell.Widgets
import "./Components"
import "../../ColorSchemes"

Item
{
    width: wifiColumn.width + 50
    height: wifiColumn.height + 10

    Colorscheme { id: theme }

    property var iB: [
        "KiB",
        "MiB",
        "GiB"
    ]

    Column {
        id: wifiColumn

        anchors.centerIn: parent
        spacing: 10

        Text {
            id: wifiName
            color: theme.colFg
            width: 156
            font { family: theme.fontFamily; pixelSize: 14; bold: true }
            renderType: Text.NativeRendering
            anchors.horizontalCenter: parent.horizontalCenter

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Row {
            spacing: 10

            Column
            {
                id: wifiInfoColumn
                spacing: 10

                Rectangle {
                    width: 265
                    height: rxColumn.height + 10
                    radius: 12 

                    color: theme.colLightBlue

                    Column
                    {
                        id: rxColumn
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        Text {
                            id: rxTitle
                            text: "RX"

                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 14; bold: true }
                            renderType: Text.NativeRendering
                            anchors.horizontalCenter: parent.horizontalCenter

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Row {
                            spacing: 25

                            SpeedOMeter { 
                                id: reciever 
                                progress: 0

                                anchors.topMargin: 10
                            }

                            Column
                            {
                                spacing: 7.5
                                anchors.verticalCenter: parent.verticalCenter

                                Row {
                                    spacing: 5

                                    IconImage{
                                        width: rxPackageMeasurement.height
                                        height: rxPackageMeasurement.height
                                        source: Qt.resolvedUrl("../Utils/Files/package.svg")
                                        mipmap: true
                                        smooth: true
                                    }

                                    Text {
                                        id: rxPackageMeasurement
                                        text: "4k (2.64 MiB)"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                                Row {
                                    spacing: 5

                                    IconImage {
                                        width: rxPackageDroppedMeasurement.height
                                        height: rxPackageDroppedMeasurement.height + 2
                                        source: Qt.resolvedUrl("../Utils/Files/package-dropped.svg")
                                        mipmap: true
                                        smooth: true
                                    }

                                    Text {
                                        id: rxPackageDroppedMeasurement
                                        text: "126 (0.96%)"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Row {
                                    spacing: 7.5
                                    Text {
                                        id: expectedSpeedIcon
                                        text: "󰓅"
                                        
                                        y: expectedSpeed.y - 5
                                        x: x - 2.5
                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: expectedSpeed.font.pixelSize*1.5; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Text {
                                        id: expectedSpeed
                                        text: "30.0 MB/s"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: 265
                    height: txColumn.height + 10
                    radius: 12

                    color: theme.colLightBlue

                    Column
                    {
                        id: txColumn
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10

                        Text {
                            id: txTitle
                            text: "TX"

                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 14; bold: true }
                            renderType: Text.NativeRendering
                            anchors.horizontalCenter: parent.horizontalCenter

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Row {
                            spacing: 25

                            SpeedOMeter { 
                                id: transmiter 
                                progress: 0

                                anchors.topMargin: 10
                            }

                            Column
                            {
                                spacing: 7.5
                                anchors.verticalCenter: parent.verticalCenter

                                Row {
                                    spacing: 5

                                    IconImage{
                                        width: txPackageMeasurement.height
                                        height: txPackageMeasurement.height
                                        source: Qt.resolvedUrl("../Utils/Files/package.svg")
                                        mipmap: true
                                        smooth: true
                                    }

                                    Text {
                                        id: txPackageMeasurement
                                        text: "4k (2.64 MiB)"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                                Row {
                                    spacing: 7.5

                                    Text {
                                        id: txPackageRertyMeasurementIcon
                                        text: "󰜉"

                                        height: txPackageRertyMeasurement.height
                                        
                                        y: txPackageRertyMeasurement.y
                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: expectedSpeed.font.pixelSize*1.5; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Text {
                                        id: txPackageRertyMeasurement
                                        text: "126 (0.96%)"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Text {
                                        id: txPackageFailureIcon
                                        text: ""
                                        
                                        y: txPackageFailure.y - 4
                                        x: x + 1
                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: expectedSpeed.font.pixelSize*1.5; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }

                                    Text {
                                        id: txPackageFailure
                                        text: "30.0 MB/s"

                                        color: theme.colFg
                                        font { family: theme.fontFamily; pixelSize: 12; bold: true }
                                        renderType: Text.NativeRendering

                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
                Rectangle {
                    width: 265
                    height: routerColumn.height + 10
                    radius: 12

                    color: theme.colLightBlue

                    Column
                    {
                        spacing: 5

                        Text {
                            id: routerTitel
                            text: " Connection Details"

                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 12; bold: true }
                            renderType: Text.NativeRendering

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        id: routerColumn
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            id: router
                            text: " 2432 MHz : channel 5 : 40 MHz"

                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 12; bold: true }
                            renderType: Text.NativeRendering

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        Text {
                            id: beacons
                            text: "󰑩 11676   231"

                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 12; bold: true }
                            renderType: Text.NativeRendering

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        
            Rectangle
            {
                id: progressBarRect

                width: progressBarRows.width + 20
                height: wifiInfoColumn.height
                radius: 12

                color: theme.colLightBlue

                Column
                {
                    spacing: 0
                    anchors.centerIn: parent

                    Text {
                        id: progressbarTitle
                        color: theme.colFg
                        font { family: theme.fontFamily; pixelSize: 13; bold: false }
                        renderType: Text.NativeRendering
                        text: " Signal Health"

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        topPadding: 5
                        
                    }

                    Row
                    {
                        id: progressBarRows
                        spacing: 10

                        height: progressBarRect.height - progressbarTitle.height

                        Text {
                            id: signalTitle
                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 16; bold: false }
                            renderType: Text.NativeRendering
                            text: "󰀂 Signal level"
                            height: implicitWidth
                            width: 16

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            y: progressBarRows.height - height - 15
                            rotation: -90
                        }

                        ProgressBar {
                            id: signalRectBar
                            width: 25
                            height: progressBarRows.height - 10
                            radius: 1
                            anchors.verticalCenter: parent.verticalCenter

                            color: "transparent"
                            innerRectColor: theme.colFg

                            isHorizontal: false
                            maxValue: 70
                            value: 0

                            Text {
                                id: signalText
                                color: theme.colDarkBlue
                                font { family: theme.fontFamily; pixelSize: 11; bold: true }
                                renderType: Text.NativeRendering
                                text: ""

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                anchors.horizontalCenter: signalRectBar.innerRect.horizontalCenter
                                property double yOffset: signalRectBar.innerRect.y + signalRectBar.innerRect.height / 2 - height / 2
                                property double yLimit: signalRectBar.height - height
                                y: (yOffset > yLimit) ? yLimit : yOffset
                            }
                        }

                        ProgressBar {
                            id: qualityRectBar
                            width: 25
                            height: progressBarRows.height - 10
                            radius: 1
                            anchors.verticalCenter: parent.verticalCenter

                            color: "transparent"
                            innerRectColor: theme.colFg

                            isHorizontal: false
                            maxValue: 70
                            value: 0

                            Column {
                                anchors.horizontalCenter: qualityRectBar.innerRect.horizontalCenter
                                property double yOffset: qualityRectBar.innerRect.y + qualityRectBar.innerRect.height / 2 - height / 2
                                property double yLimit: qualityRectBar.height - height
                                y: (yOffset > yLimit) ? yLimit : yOffset

                                Text {
                                    id: qualityText
                                    color: theme.colDarkBlue
                                    font { family: theme.fontFamily; pixelSize: 11; bold: true }
                                    renderType: Text.NativeRendering
                                    text: ""

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }

                                Text {
                                    id: dashText
                                    color: theme.colDarkBlue
                                    font { family: theme.fontFamily; pixelSize: 16; bold: true }
                                    renderType: Text.NativeRendering
                                    text: ""

                                    height: 5

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter

                                    x: -3


                                }

                                Text {
                                    id: seventyText
                                    color: theme.colDarkBlue
                                    font { family: theme.fontFamily; pixelSize: 11; bold: true }
                                    renderType: Text.NativeRendering
                                    text: "70"

                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }

                        Text {
                            id: qualityTitle
                            color: theme.colFg
                            font { family: theme.fontFamily; pixelSize: 16; bold: false }
                            renderType: Text.NativeRendering
                            text: " Link quality"
                            height: implicitWidth
                            width: 16

                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            y: progressBarRows.height - height - 15
                            rotation: 270

                        }
                    }
                }
            }
        }
    }

    property var iBconvertion: function(x) {
        let i = -1 ;
        while (true)
        {

            if (x < Math.pow(2, (i + 2) * 10)) 
            {
                x = x / Math.pow(2, (i + 1) * 10);
                break;
            }

            i++;
        }
        if (i == -1) return String(x.toFixed(2));
        else return x.toFixed(2) + " " + iB[i];  
    }

    Process {
        id: wifiShellCommand
        command: ["bash", "-c", "echo \"SSID: $(iw dev wlan0 link | awk -F': ' '/SSID/{print $2}')\" && iw dev wlan0 station dump"]
        // 2. Capture standard output
        stdout: StdioCollector {
            id: stdoutCollector
        }

        onExited: (code, status) => {
            var stdoutList = stdoutCollector.text.trim().split("\n");

            let match = stdoutList[1].match(/\(on\s+([^)]+)\)/);
            let interfaceName = match ? match[1] : "";
            wifiName.text = stdoutList[0].replace("SSID: ", "").trim() + " | " + interfaceName;
            
            let signalNumber = stdoutList[19].match(/-?\d+/g);
            signalRectBar.value = signalRectBar.maxValue + (Number(signalNumber[0]) + 30);
            signalText.text = signalNumber[0] + "\ndbm";

            let RX = Number(stdoutList[24].match(/-?\d+/g)[0]) / 8;
            reciever.progress = reciever.speedToProgress(RX.toFixed(1));
            reciever.currentMeasurement.text = RX.toFixed(1);

            let RXPackages = stdoutList[11].match(/-?\d+/g) / 1000;
            let RXNumberiB = stdoutList[10].match(/-?\d+/g);
            rxPackageMeasurement.text = RXPackages.toFixed(0) + "k (" + iBconvertion(RXNumberiB) + ")"

            let RXPackagesDrop = stdoutList[18].match(/-?\d+/g)
            rxPackageDroppedMeasurement.text = RXPackagesDrop + " (" + ((RXPackagesDrop / (RXPackages * 1000)) * 100).toFixed(2) + "%)"  

            expectedSpeed.text = (stdoutList[26].match(/-?\d+(?:\.\d+)?/g) / 8).toFixed(2) + " MB/s"
            
            let TX = Number(stdoutList[22].match(/-?\d+/g)[0]) / 8;
            transmiter.progress = transmiter.speedToProgress(TX.toFixed(1));
            transmiter.currentMeasurement.text = TX.toFixed(1);

            let TXPackages = stdoutList[13].match(/-?\d+/g) / 1000;
            let TXNumberiB = stdoutList[12].match(/-?\d+/g);
            txPackageMeasurement.text = TXPackages.toFixed(0) + "k (" + iBconvertion(TXNumberiB) + ")"
            
            let TXRetry = stdoutList[14].match(/-?\d+/g) / 1000
            txPackageRertyMeasurement.text = TXRetry.toFixed(0) + "k (" + (TXRetry/TXPackages*100).toFixed(2) + "%)"

            txPackageFailure.text = stdoutList[15].match(/-?\d+/g)[0]

            let beaconsRX = stdoutList[17].match(/-?\d+/g)
            let beaconsLoss = stdoutList[16].match(/-?\d+/g)
            beacons.text = "󰑩 " + beaconsRX + "   " + beaconsLoss
            
        }
    }

    Process {
        id: linkQualityCommand
        command: ["bash", "-c", "grep wlan0 /proc/net/wireless | awk '{print int($3)}'"]

        // 2. Capture standard output
        stdout: SplitParser{
            onRead: (line) => {
                qualityRectBar.value = Number(line) 
                qualityText.text = line
            }
        }
    }

    Process {
        id: signalFrequencyCommand
        command: ["bash", "-c", "iw dev wlan0 info | grep \"channel\""]

        // 2. Capture standard output
        stdout: SplitParser{
            onRead: (line) => {
                let numberList = line.match(/-?\d+/g)
                router.text = " " + numberList[1] + " MHz : Channel " + numberList[0] + " : " + numberList[2] + " MHz"

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
        signalFrequencyCommand.running = true
    }
}
