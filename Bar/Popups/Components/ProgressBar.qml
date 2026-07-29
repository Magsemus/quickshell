import Quickshell 
import QtQuick
import "../../../ColorSchemes"

Rectangle {

    property int value
    property int maxValue
    property var innerRectColor
    property bool isHorizontal: true
    property Rectangle innerRect: _innerRect

    Colorscheme { id: theme }

    color: "transparent"
    radius: 1

    Rectangle
    {
        id: _innerRect

        width: (isHorizontal ? parent.width * (value / maxValue) : parent.width) - parent.border.width*2
        height: (isHorizontal ? parent.height : parent.height * (value / maxValue)) - parent.border.width*2
        color: innerRectColor
        
        x: parent.border.width
        y: parent.border.width

        topLeftRadius: isHorizontal ? parent.radius : ((width > (parent.width - parent.radius) || width < parent.radius) ? parent.radius : 0)
        bottomLeftRadius: parent.radius
        topRightRadius: (width > (parent.width - parent.radius) || width < parent.radius) ? parent.radius : 0
        bottomRightRadius: isHorizontal ? ((width > (parent.width - parent.radius) || width < parent.radius) ? parent.radius : 0) : parent.radius
        
        anchors.bottom: isHorizontal ? undefined : parent.bottom
        Behavior on width {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }

        Behavior on height {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }

        Behavior on topRightRadius {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }

        Behavior on bottomRightRadius {
            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
        }
    }
}
