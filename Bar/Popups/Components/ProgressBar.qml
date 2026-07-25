import Quickshell 
import QtQuick
import "../../../ColorSchemes"

Rectangle {

    property int value
    property int maxValue
    property var innerRectColor

    Colorscheme { id: theme }

    color: "transparent"
    radius: 12

    Rectangle
    {
        
        width: parent.width * (value / maxValue) - parent.border.width*2
        height: parent.height - parent.border.width*2
        color: innerRectColor
        
        x: parent.border.width
        y: parent.border.width

        topLeftRadius: parent.radius
        bottomLeftRadius: parent.radius
        topRightRadius: (width > (parent.width - parent.radius) || width < parent.radius) ? parent.radius : 0
        bottomRightRadius: (width > (parent.width - parent.radius) || width < parent.radius) ? parent.radius : 0

        Behavior on width {
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
