import Quickshell 
import QtQuick
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts
import "./Components"
import "../../ColorSchemes"
import "../Components/Base"

Item {
    id: root

    width: loader.width 
    height: loader.height

    component StyledText : Text {
        id: wifiDiagnosticsItem
        property alias pixelSize: wifiDiagnosticsItem.font.pixelSize

        color: theme.colFg
        renderType: Text.NativeRendering
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.family: theme.fontFamily
        font.pixelSize: 12
        font.bold: true
    }

    Colorscheme { id: theme }

    Component {
        id: wifiDiagnostics

        Item
        {
            id: wifiDiagnosticsItem

            width: wifiColumn.width + 50
            height: wifiColumn.height + 10

            property var iB: [
                "KiB",
                "MiB",
                "GiB"
            ]

            property string name

            Column {
                id: wifiColumn

                anchors.centerIn: parent
                spacing: 10

                StyledText {
                    id: wifiName
                    width: 156
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    spacing: 10

                    Column {
                        id: wifiInfoColumn
                        spacing: 10

                        Rectangle {
                            width: 265
                            height: rxColumn.height + 10
                            radius: 12 

                            color: theme.colLightBlue

                            Column {
                                id: rxColumn
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                StyledText {
                                    id: rxTitle
                                    text: "RX"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row {
                                    spacing: 25

                                    SpeedOMeter { 
                                        id: reciever 
                                        progress: 0

                                        anchors.topMargin: 10
                                    }

                                    Column {
                                        spacing: 7.5
                                        anchors.verticalCenter: parent.verticalCenter

                                        Row {
                                            spacing: 5

                                            IconImage {
                                                width: rxPackageMeasurement.height
                                                height: rxPackageMeasurement.height
                                                source: Qt.resolvedUrl("../Utils/Files/package.svg")
                                                mipmap: true
                                                smooth: true
                                            }

                                            StyledText {
                                                id: rxPackageMeasurement
                                                text: "0"
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

                                            StyledText {
                                                id: rxPackageDroppedMeasurement
                                            }
                                        }

                                        Row {
                                            spacing: 7.5

                                            StyledText {
                                                id: expectedSpeedIcon
                                                text: "󰓅"
                                                y: expectedSpeed.y - 5
                                                transform: Translate { x: -2.5 }
                                                font.pixelSize: expectedSpeed.font.pixelSize * 1.5
                                            }

                                            StyledText {
                                                id: expectedSpeed
                                                text: "0"
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

                            Column {
                                id: txColumn
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10

                                StyledText {
                                    id: txTitle
                                    text: "TX"
                                    font.pixelSize: 14
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Row {
                                    spacing: 25

                                    SpeedOMeter { 
                                        id: transmiter 
                                        progress: 0

                                        anchors.topMargin: 10
                                    }

                                    Column {
                                        spacing: 7.5
                                        anchors.verticalCenter: parent.verticalCenter

                                        Row {
                                            spacing: 5

                                            IconImage {
                                                width: txPackageMeasurement.height
                                                height: txPackageMeasurement.height
                                                source: Qt.resolvedUrl("../Utils/Files/package.svg")
                                                mipmap: true
                                                smooth: true
                                            }

                                            StyledText {
                                                id: txPackageMeasurement
                                                text: "0"
                                            }
                                        }

                                        Row {
                                            spacing: 7.5

                                            StyledText {
                                                id: txPackageRertyMeasurementIcon
                                                text: "󰜉"
                                                height: txPackageRertyMeasurement.height
                                                y: txPackageRertyMeasurement.y
                                                font.pixelSize: expectedSpeed.font.pixelSize * 1.5
                                            }

                                            StyledText {
                                                id: txPackageRertyMeasurement
                                            }
                                        }

                                        Row {
                                            spacing: 10

                                            StyledText {
                                                id: txPackageFailureIcon
                                                text: ""
                                                y: txPackageFailure.y - 4
                                                transform: Translate { x: 1 }
                                                font.pixelSize: expectedSpeed.font.pixelSize * 1.5
                                            }

                                            StyledText {
                                                id: txPackageFailure
                                                text: "0"
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

                            Column {
                                id: routerColumn
                                spacing: 5

                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.verticalCenter: parent.verticalCenter

                                StyledText {
                                    id: routerTitel
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: " Connection info"
                                }

                                StyledText {
                                    id: router
                                    text: "0"
                                }

                                StyledText {
                                    id: beacons
                                    text: "0"
                                }
                            }
                        }
                    }

                    Rectangle {
                        id: progressBarRect

                        width: progressBarRows.width + 20
                        height: wifiInfoColumn.height
                        radius: 12

                        color: theme.colLightBlue

                        Column {
                            spacing: 0
                            anchors.centerIn: parent

                            StyledText {
                                id: progressbarTitle
                                text: " Signal Health"
                                font.pixelSize: 13
                                font.bold: false
                                anchors.horizontalCenter: parent.horizontalCenter
                                topPadding: 5
                            }

                            Row {
                                id: progressBarRows
                                spacing: 10

                                height: progressBarRect.height - progressbarTitle.height

                                StyledText {
                                    id: signalTitle
                                    text: "󰀂 Signal level"
                                    font.pixelSize: 16
                                    font.bold: false
                                    height: implicitWidth
                                    width: 16
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

                                    StyledText {
                                        id: signalText
                                        color: theme.colDarkBlue
                                        font.pixelSize: 11
                                        text: "0"

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

                                        StyledText {
                                            id: qualityText
                                            color: theme.colDarkBlue
                                            font.pixelSize: 11
                                            text: "0"
                                        }

                                        StyledText {
                                            id: dashText
                                            text: ""
                                            color: theme.colDarkBlue
                                            font.pixelSize: 16
                                            height: 5
                                            x: -3
                                        }

                                        StyledText {
                                            id: seventyText
                                            text: "70"
                                            color: theme.colDarkBlue
                                            font.pixelSize: 11
                                        }
                                    }
                                }

                                StyledText {
                                    id: qualityTitle
                                    text: " Link quality"
                                    font.pixelSize: 16
                                    font.bold: false
                                    height: implicitWidth
                                    width: 16
                                    y: progressBarRows.height - height - 15
                                    rotation: 270
                                }
                            }
                        }
                    }
                }

                Row {
                    id: buttonRow
                    spacing: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    ServiceButton {
                        id: disconnect
                        activeIcon: ""
                        widthOffset: 15
                        pixelSize: 24
                        clickAble: true
                        onClickedAction: () => {
                            Quickshell.execDetached(["nmcli", "device", "disconnect", wifiDiagnosticsItem.name])
                            loader.sourceComponent = wifiConnectionNames
                            console.log("TEST!!!! " + root.width)
                        }
                    }

                    ToggleSwitch {
                        id: wifiToggle
                        width: 50
                        height: 20
                        innerCircleColor: theme.colFg
                        colorOff: theme.colDarkerBlue
                        colorOn: theme.colLightBlue
                        anchors.verticalCenter: parent.verticalCenter
                        clickAction: () => {
                            toggle = !toggle
                            runProcess()
                        }
                        procAction: "if [ \"$(nmcli radio wifi)\" = \"enabled\" ]; then nmcli radio wifi off; else nmcli radio wifi on; fi"
                    }
                }
            }

            Process {
                id: wifiShellCommand
                command: ["bash", "-c", `echo "SSID: $(iw dev ${wifiDiagnosticsItem.name} link | awk -F': ' '/SSID/{print $2}')" && iw dev ${wifiDiagnosticsItem.name} station dump`]

                stdout: StdioCollector {
                    id: stdoutCollector
                }

                onExited: (code, status) => {
                    let lines = stdoutCollector.text.trim().split("\n");
                    if (lines.length < 2) return;

                    // Extract SSID (Line 0)
                    let ssid = lines[0].replace(/^SSID:\s*/, "").trim();

                    // Parse key-value pairs from `iw station dump` to avoid fragile hardcoded array indexes
                    let stats = {};
                    for (let i = 1; i < lines.length; i++) {
                        let line = lines[i].trim();

                        // Match station line to extract interface: "Station aa:bb:cc (on wlan0)"
                        let stationMatch = line.match(/\(on\s+([^)]+)\)/);
                        if (stationMatch) {
                            stats["interface"] = stationMatch[1];
                            continue;
                        }

                        // Map line headers (e.g., "rx bytes: 123456") to stats key-value pairs
                        let colonIdx = line.indexOf(":");
                        if (colonIdx !== -1) {
                            let key = line.substring(0, colonIdx).trim();
                            let val = line.substring(colonIdx + 1).trim();
                            stats[key] = val;
                        }
                    }

                    // Helper function for safe number extraction
                    let getNum = (str, index = 0) => {
                        if (!str) return 0;
                        let m = str.match(/-?\d+(?:\.\d+)?/g);
                        return m && m[index] !== undefined ? Number(m[index]) : 0;
                    };

                    let iBconvertion = (x) => {
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

                    let kConvertion = (x) => {
                        if (x > 1000) return String((x / 1000).toFixed(0)) + "k"
                        return String(x)
                    }

                    // UI Updates
                    let interfaceName = stats["interface"] || "";
                    wifiName.text = `${ssid} | ${interfaceName}`;

                    // Signal dBm
                    let signal = getNum(stats["signal"]);
                    signalRectBar.value = signalRectBar.maxValue + (signal + 30);
                    signalText.text = `${signal}\ndbm`;

                    // RX / TX Speeds (Bitrates)
                    let rxBitrate = getNum(stats["rx bitrate"]); // Bitrate in MBit/s
                    let rxSpeed = (rxBitrate / 8).toFixed(1);
                    reciever.progress = reciever.speedToProgress(rxSpeed);
                    reciever.currentMeasurement.text = rxSpeed;

                    let txBitrate = getNum(stats["tx bitrate"]);
                    let txSpeed = (txBitrate / 8).toFixed(1);
                    transmiter.progress = transmiter.speedToProgress(txSpeed);
                    transmiter.currentMeasurement.text = txSpeed;

                    // Expected / Theoretical Speed
                    let expected = (getNum(stats["expected throughput"]) / 8).toFixed(2);
                    expectedSpeed.text = `${expected} MB/s`;

                    // RX Packages & Bytes
                    let rxPackets = getNum(stats["rx packets"]);
                    let rxBytes = getNum(stats["rx bytes"]);
                    rxPackageMeasurement.text = `${kConvertion(rxPackets)} (${iBconvertion(rxBytes)})`;

                    let rxDrop = getNum(stats["rx drop misc"]);
                    let rxDropPct = rxPackets > 0 ? ((rxDrop / (rxPackets)) * 100).toFixed(2) : "0.00";
                    rxPackageDroppedMeasurement.text = `${rxDrop} (${rxDropPct}%)`;

                    // TX Packages & Retries
                    let txPackets = getNum(stats["tx packets"]);
                    let txBytes = getNum(stats["tx bytes"]);
                    txPackageMeasurement.text = `${kConvertion(txPackets)} (${iBconvertion(txBytes)})`;

                    let txRetry = getNum(stats["tx retries"]); // or stats["tx retries"]
                    let txRetryPct = txPackets > 0 ? ((txRetry / txPackets) * 100).toFixed(2) : "0.00";
                    txPackageRertyMeasurement.text = `${kConvertion(txRetry)} (${txRetryPct}%)`;

                    txPackageFailure.text = getNum(stats["tx failed"]).toString();

                    // Beacons
                    let beaconsRx = getNum(stats["beacon rx"]);
                    let beaconsLoss = getNum(stats["beacon loss"]);
                    beacons.text = `󰑩 ${beaconsRx}   ${beaconsLoss}`;
                }
            }

            Process {
                id: linkQualityCommand
                command: ["bash", "-c", `grep ${wifiDiagnosticsItem.name} /proc/net/wireless | awk '{print int($3)}'`]

                stdout: SplitParser {
                    onRead: (line) => {
                        let val = Number(line) || 0;
                        qualityRectBar.value = val;
                        qualityText.text = line;
                    }
                }
            }

            Process {
                id: signalFrequencyCommand
                command: ["bash", "-c", `iw dev ${wifiDiagnosticsItem.name} info | grep "channel"`]

                stdout: SplitParser {
                    onRead: (line) => {
                        let nums = line.match(/-?\d+/g);
                        if (nums && nums.length >= 3) {
                            router.text = ` ${nums[1]} MHz : Channel ${nums[0]} : ${nums[2]} MHz`;
                        }
                    }
                }
            }

            Process{
                id: interfaceName
                command: ["bash", "-c", "nmcli"]

                stdout: StdioCollector {
                    id: interfaceNameCollector
                }

                onExited: (code, status) => {
                    var lines = interfaceNameCollector.text.trim().split("\n");
                    wifiDiagnosticsItem.name = lines[0].match(/^[^:]+(?=:)/)?.[0];

                    wifiShellCommand.running = true;
                    linkQualityCommand.running = true;
                    signalFrequencyCommand.running = true;
                    checkStatusProc.running = true;
                }
            }

            Process {
                id: nmcliDBusListener

                // Monitor DBus system signals for NetworkManager directly
                command: [
                    "gdbus", "monitor", 
                    "--system", 
                    "--dest", "org.freedesktop.NetworkManager", 
                    "--object-path", "/org/freedesktop/NetworkManager"
                ]
                running: true

                stdout: SplitParser {
                    onRead: (line) => {
                        // React immediately when NetworkManager fires a DBus signal event
                        if ((line.includes("StateChanged") || line.includes("PropertiesChanged")) && (line.includes("20") || line.includes("70"))) {
                            // Update state cleanly without overflowing DBus
                            checkStatusProc.running = true
                            
                            // Update the interface name when connected to wifi
                            if (line.includes("70"))
                            {
                                interfaceName.running = true
                            }
                        }
                    }
                }
            }

            Process {
                id: checkStatusProc
                command: ["nmcli", "-t", "-f", "WIFI", "radio"]
                running: true // Run once on load

                stdout: StdioCollector {
                    onStreamFinished: {
                        let output = text.trim()
                        wifiToggle.toggle = (output === "enabled")
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
                interfaceName.running = true
            }
        }
    }
    
    Component {
        id: wifiConnectionNames

        Item
        {
            id: wifiConnectionNamesItem
            width: 350
            height: (root.heightOfBackgroundRect > 0) ? root.height : wifiConnectionNamesColumn.height

            Column {
                id: wifiConnectionNamesColumn

                width: wifiConnectionNamesItem.width
                spacing: 2

                StyledText {
                    id: title
                    text: "Connections" 
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                ScrollView {
                    id: scrollView

                    width: wifiConnectionNamesColumn.width
                    height: 250
                    anchors.horizontalCenter: parent.horizontalCenter

                    ScrollBar.vertical.policy: ScrollBar.AsNeeded
                    clip: true

                    property list<string> listOfNames

                    Process {
                        id: getNamesOfConnections

                        command: ["nmcli", "-t", "-f", "ssid", "dev", "wifi"]

                        running: true

                        stdout: SplitParser {
                            onRead: (line) => {
                                let output = line.trim() // Corrected variable name
                                if (output !== "") {     // Corrected operator
                                    scrollView.listOfNames.push(String(output))
                                    console.log(output)
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        width: scrollView.availableWidth
                        spacing: 1

                        Repeater {
                            model: scrollView.listOfNames.length

                            ServiceButton {
                                activeIcon: scrollView.listOfNames[index]
                                onClickedAction: () => {
                                    //loader.sourceComponent = wifiConnectPanel
                                    connectToNetwork.running = true
                                }
                                width: scrollView.width
                                textInCenter: false
                                textComponent.x: 7

                                Process {
                                    id: connectToNetwork

                                    command: ["bash", "-c", `nmcli device wifi connect "${activeIcon}"`]

                                    stdout: StdioCollector {
                                        id: stdoutCollector
                                    }

                                    onExited: (code, status) => {
                                        if (stdoutCollector.text.includes("successfully activated")) {
                                            loader.sourceComponent = wifiDiagnostics
                                            root.height = loader.height
                                        }
                                        else {
                                            networkName = activeIcon
                                            loader.sourceComponent = wifiConnectPanel
                                        }
                                    }
                                }
                            }
                        }
                    }

                    HoverHandler {
                        id: wifiConnectionNamesHandler

                        onHoveredChanged: {
                            if (hovered) {
                                root.height = wifiConnectionNamesColumn.height;
                            }
                        }
                    }
                }
            }

            Behavior on height{
                NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
            }
        }
    }

    property var heightOfBackgroundRect: parent.backgroundRect.height

    onHeightOfBackgroundRectChanged: {
        if (parent.backgroundRect.height == 0 && loader.sourceComponent == wifiConnectPanel) {
            loader.sourceComponent = wifiConnectionNames
            parent.backgroundRect.rectHeight = loader.height
        }
    }

    property string networkName

    Component {
        id: wifiConnectPanel

        Item {
            id: wifiConnectPanelItem

            width: root.width
            height: root.height

            Process {
                id: connectToNetworkWithPassword

                command: ["bash", "-c", `nmcli device wifi connect "${root.networkName}" password "${textInput.text}"`]

                stdout: StdioCollector {
                    id: stdoutCollector
                }

                onExited: (code, status) => {
                    console.log("TRYING TO CONNECT")
                    if (!stdoutCollector.text.includes("successfully activated")) {
                        textInput.text = ""

                        textInputInnerText.text = "Wrong password"
                        color: "#FF0000"
                    }
                }
            }

            Column
            {
                id: wifiConnectPanelColumn
                anchors.centerIn: parent
                spacing: 10

                Rectangle
                {
                    id: inputBarRect

                    width: wifiConnectPanelItem.width - 10
                    height: 35
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: 12
                    color: theme.colDarkerBlue

                    TextInput {
                        id: textInput
                        anchors.fill: parent
                        anchors.margins: 10

                        verticalAlignment: Text.AlignVCenter
                        color: theme.colFg
                        font.pixelSize: 14
                        clip: true 

                        echoMode: checkMark.marked ? TextInput.Normal : TextInput.Password

                        Text {
                            id: textInputInnerText
                            text: "Type the wifi password here"
                            color: "#6c7086"
                            font: parent.font
                            visible: !textInput.text && !textInput.activeFocus
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        onAccepted: {
                            parent.forceActiveFocus();
                            connectToNetworkWithPassword.running = true;
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textInput.forceActiveFocus();
                        }
                        //z: -1 // Sits behind TextInput so selection still works
                    }
                }
                
                Item {
                    width: parent.width
                    height: checkMark.height + 5

                    CheckMark { 
                        id: checkMark 
                        width: 20
                        height: 20
                        radius: 4
                        x:10
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    ServiceButton{
                        anchors.centerIn: parent
                        activeIcon: "connect"
                        backgroundColor: theme.colLightBlue
                        widthOffset: 20
                        onClickedAction: () => {
                            connectToNetworkWithPassword.running = true;
                        }
                    }
                }
            }
        }
    }

    Loader {
        id: loader

        anchors.centerIn: parent
        //sourceComponent: wifiDiagnostics

        onWidthChanged: {
            root.width = width
        }
    }

    Component.onCompleted: {
        //root.width = loader.width
        checkConnectionProcess.running = true
    }

    property bool connected: false

    Process {
        id: nmcliDBusListenerForComponents

        // Monitor DBus system signals for NetworkManager directly
        command: [
            "gdbus", "monitor", 
            "--system", 
            "--dest", "org.freedesktop.NetworkManager", 
            "--object-path", "/org/freedesktop/NetworkManager"
        ]
        running: true

        stdout: SplitParser {
            onRead: (line) => {
                // React immediately when NetworkManager fires a DBus signal event

                if ((line.includes("StateChanged") || line.includes("PropertiesChanged") && (line.includes("20") || line.includes("70")))) {
                    // Update state cleanly without overflowing DBus
                    console.log(line)
                    if (connected || line.includes("70")) {
                        connected = false
                        checkConnectionProcess.running = true
                    }
                }
            }
        }
    }

    Process
    {
        id: checkConnectionProcess
        command: ["bash", "-c", "nmcli -t -f WIFI radio && iw dev | grep Interface && nmcli -g DEVICE,STATE device"]

        stdout: StdioCollector {
            id: shellCommandCollector
        }

        onExited: (code, status) => {
            let lines = shellCommandCollector.text.trim().split("\n");
            let interfaceName = lines[1].replace("Interface ", "").trim() + ":disconnected";
            let disconnected = false
            
            for (let i = 1 ; i < lines.length ; i++)
            {
                if (lines[0] == "enabled" && lines[i].trim() == interfaceName )
                {
                    loader.sourceComponent = wifiConnectionNames
                    disconnected = true
                    break;
                }
            }

            if (!disconnected) {
                connected = true
                loader.sourceComponent = wifiDiagnostics
            }

            parent.backgroundRect.rectHeight = loader.height

            if (parent.backgroundRect.height > 0) {
                root.height = loader.height
            }
        }
    }
}
