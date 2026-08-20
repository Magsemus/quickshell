import QtQuick

ListView {
    id: baseList
    
    property bool enableYAnimation: true
    property int yOffset: 5
    
    add: Transition {
        ParallelAnimation {
            NumberAnimation { property: enableYAnimation ? "y" : ""; from: ViewTransition.destination.y + yOffset; to: ViewTransition.destination.y; duration: 250; easing.type: Easing.OutQuad }
            NumberAnimation { property: "scale"; from: 0.0; to: 1.0; duration: 250; easing.type: Easing.OutQuad }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 250 }
        }
    }

    remove: Transition {
        ParallelAnimation {
            NumberAnimation { property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
            NumberAnimation { property: "opacity"; to: 0.0; duration: 200 }
        }
    }

    displaced: Transition {
        NumberAnimation { 
            properties: "x,y"
            duration: 250
            easing.type: Easing.OutQuad
        }
    }

    Component.onCompleted: {
        opacity = 1.0
        scale = 1.0
    }

    reuseItems: false
}
