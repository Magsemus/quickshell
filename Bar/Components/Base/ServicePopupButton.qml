import Quickshell
import QtQuick


Item {
    width: _scriptButton.width
    height: _scriptButton.height

    function getHeightOffset(module) : int
    {   
        if (!module || !parent) return 0;

        let sum = 0;
        let currentParent = module;

        while (currentParent)
        {
            sum = sum + currentParent.y;
            currentParent = currentParent.parent;
        }

        return (sum + module.height);
    }
    
    property var serviceMouseArea
    property var servicePopup
    property var content

    property string scriptPath: ""
    property var procAction: function() {}
    property string textIcon: ""
    property string buttonAnimationType: "pop"

    function triggerIconUpdate(nextIcon) {
        _scriptButton.triggerIconUpdate(nextIcon);
    }

    ServiceScriptButton {
        id: _scriptButton
        clickedAction: function() { 
            let Y = getHeightOffset(this) + 1;
            serviceMouseArea.yOffset = servicePopup.y - Y

            if (servicePopup.contentLoader.source != "../../Popups/" + content + ".qml") 
            { 
                servicePopup.contentLoader.source = "../../Popups/" + content + ".qml"
                console.log(servicePopup.contentLoader.source)
                servicePopup.module = this

                serviceMouseArea.y = Y;
                serviceMouseArea.height = servicePopup.rectHeight + serviceMouseArea.yOffset;
                serviceMouseArea.hoveringHandler.enabled = true
            }
            else
            {
                servicePopup.height = servicePopup.rectHeight;
                serviceMouseArea.height = servicePopup.rectHeight + (servicePopup.y - Y);
                serviceMouseArea.hoveringHandler.enabled = true
            }
        }
        mouseHoverExit: function () {
            if (servicePopup.height > 0)
            {
                servicePopup.height = 0;
                serviceMouseArea.height = 0;
            }
        }

        scriptPath: parent.scriptPath
        procAction: parent.procAction
        textIcon: parent.textIcon
        buttonAnimationType: parent.buttonAnimationType
    }
}
