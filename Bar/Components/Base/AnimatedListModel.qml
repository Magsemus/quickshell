import QtQuick

AnimatedListView {
    id: root

    ListModel {
        id: _animatedList
    }

    property var listToTrack
    property alias animatedList: _animatedList

    property var isElementInList: (item) => {
        for (let j = 0; j < _animatedList.count; j++) {
            if (_animatedList.get(j) === item) {
                return true;
            }
        }
        return false;
    }

    property var addToList: (item) => {
        _animatedList.append(item);
    }

    property var isElementRemoved: (item) => {
        if (!listToTrack.includes(item)) {
            // Use setProperty to update roles inside a ListModel
            removeElement(item);
        }
    }

    property var removeHandler: (targetItem, item, i) => {
        if (item === targetItem) {
            // ListModel.remove triggers native ListView 'remove' transitions
            _animatedList.remove(i);
        }
    }

    property var checkList: () => {
        // 1. Add new valid devices
        for (let i = 0; i < listToTrack.length; i++) {
            let item = listToTrack[i];
            if (!item) continue;

            // Check existence using ListModel.get()
            let exists = isElementInList(item);

            if (!exists) {
                // ListModel.append triggers native ListView 'add' transitions
                addToList(item);
            }
        }

        // 2. Mark removed devices
        for (let i = 0; i < _animatedList.count; i++) {
            let item = animatedList.get(i);
            isElementRemoved(item);
        }
    }

    onListToTrackChanged: {
        checkList();
    }

    function removeElement(targetItem) {
        // Loop backwards to remove safely by index
        for (let i = _animatedList.count - 1; i >= 0; i--) {
            let item = animatedList.get(i);
            removeHandler(targetItem, item, i)
        }
    }
    
    enableYAnimation: root.enableYAnimation ?? true
    orientation: ListView.Vertical
    spacing: 8

    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
    }

    Behavior on y {
        NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
    }

    model: _animatedList
}
