import Quickshell // for PanelWindow
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick // for Text
import QtQuick.Layouts
import "../../../ColorSchemes"

Item
{
    id: root

    property string activeIcon: ""
    property var onClickedAction: function () { console.log("No action defined") }
    property var onMouseHoverExit: function () {}
    property bool clickAble: true
    property bool hoverAble: true
    property string animationType: "pop"
    property var textColor: theme.colFg
    property bool isCircle: false
    property int buttonRadius: iconText.width + widthOffset
    property int cornerRadius: 12
    property int widthOffset: 0
    property int heightOffset: 0
    property Rectangle buttonRect: buttonRect 

    width: iconText.width + widthOffset
    height: iconText.height + heightOffset

    Rectangle
    {
        id: buttonRect
        
        width: isCircle ? buttonRadius : parent.width
        height: isCircle ? buttonRadius : parent.width
        radius: isCircle ? 100 * width : cornerRadius

        anchors.verticalCenter: parent.verticalCenter

        Colorscheme { id: theme } 

        color: (clickAble || hoverAble) ? (mouseArea.containsPress ? theme.colClickBlue : (mouseArea.containsMouse ? theme.colHoverBlue : "transparent")) : "transparent"

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    function updateIcon(nextIcon)
    {
        if (activeIcon == nextIcon) return;

        if (animationType == "pop")
        {
            popAnimation.animations[1].value = nextIcon;
            popAnimation.start();
        }
        else if (animationType == "fade") 
        {
            incomingText.text = nextIcon;
            fadeAnimation.start();
        }
        else
        {
            activeIcon = nextIcon;
        }
    }

    Text
    {
        id: iconText
        anchors.centerIn: parent
        text: root.activeIcon
        color: textColor
        font { family: "JetBrainsMonoNerdFontPropo-Regular"; pixelSize: 14; bold: true }
        renderType: Text.NativeRendering
        transformOrigin: Item.Center
        opacity: 1.0

        Behavior on color {
            ColorAnimation {
                duration: 300
                easing.type: Easing.InOutQuad
            }
        }
    }

    Text
    {
        id: incomingText
        anchors.centerIn: parent
        text: root.activeIcon
        color: textColor
        font { family: "JetBrainsMonoNerdFontPropo-Regular"; pixelSize: 14; bold: true }
        renderType: Text.NativeRendering
        transformOrigin: Item.Center
        opacity: 0.0
    }


    SequentialAnimation {
        id: popAnimation

        // Step A: Shrink the old icon down to nothing
        NumberAnimation { 
            target: iconText; property: "scale"
            to: 0; duration: 150; easing.type: Easing.InQuad 
        }

        // Step B: Swap the text string instantly while it is invisible
        PropertyAction { 
            target: root; property: "activeIcon"
            // We pass the new icon dynamically when starting the animation
        }

        // Step C: Pop it back up to full size with the spring effect
        NumberAnimation { 
            target: iconText; property: "scale"
            to: 1; duration: 200; easing.type: Easing.OutQuad
            easing.amplitude: 1.6
        }
    }

    SequentialAnimation {
        id: fadeAnimation

        ParallelAnimation {
            NumberAnimation { target: iconText; property: "opacity"; to: 0.0; duration: 200; easing.type: Easing.OutQuad }
            NumberAnimation { target: incomingText; property: "opacity"; to: 1.0; duration: 200; easing.type: Easing.OutQuad }
        }

        ScriptAction {
            script: {
                // Instantly promote the incoming icon value to the primary activeIcon property
                root.activeIcon = incomingText.text;

                // Instantly snap the opacities back to default states behind the scenes
                iconText.opacity = 1.0;
                incomingText.opacity = 0.0;
                incomingText.text = "";
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!root.clickAble)
            {
                root.onClickedAction()
            }
        }

        onExited: {
            if (!root.clickAble)
            {
                root.onMouseHoverExit()
            }
        }

        onClicked: {
            if (root.clickAble)
            {
                root.onClickedAction()
            }
        }
    }
}
