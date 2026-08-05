import Quickshell 
import QtQuick
import Quickshell.Io

Rectangle {
    id: backgroundRect

    property bool toggle: false
    property var colorOn: "green"
    property var colorOff: "red"
    property int innerCircleOffset: 2
    property var innerCircleColor: "#FFFFFF"
    property int innerCircleOffsetSize: 2
    property var clickAction: () => {
        toggle = !toggle
    }
    property string procAction
    function runProcess() {
        toggleProcess.running = true
    }

    radius: 24

    color: toggle ? colorOn : colorOff

    Rectangle {
        id: innerCircle

        width: (parent.height - innerCircleOffsetSize)
        height: (parent.height - innerCircleOffsetSize)
        radius: width * 100
        color: innerCircleColor

        anchors.verticalCenter: parent.verticalCenter

        x: toggle ? (parent.width - (innerCircleOffset + width + 2)) : innerCircleOffset

        Behavior on x {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }
    
    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            clickAction()
        }

        Process {
            id: toggleProcess
            command: ["bash", "-c", procAction]
        }
    }

}
