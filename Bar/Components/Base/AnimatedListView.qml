import QtQuick

ListView {
    id: baseList

    add: Transition {
        ParallelAnimation {
            NumberAnimation { property: "y"; from: 5; to: 0; duration: 250; easing.type: Easing.OutQuad }
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

    Component.onCompleted: {
        opacity = 1.0
        scale = 1.0
    }

    reuseItems: false
}
