import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PanelWindow{
    // popup positioning, can be used for any popup

    anchors.top: true;
    anchors.left: (GlobalStates.leftPopup === "") ? false : true;
    anchors.right: (GlobalStates.rightPopup === "") ? false : true;

    // defaultMargin will position the middle of the popup to the margins of the panel begining
    property real defaultMargin: (Config.margin / 2) + Config.radius - (implicitWidth/2);
    
    // Left properties
    property int leftIndex: GlobalStates.leftPopupCallerIndex ?? 0; // Index of the left caller
    property var leftElements: GlobalStates.leftElementWidth ?? []; // The same array as leftElementWidth or an empty array
    property real leftSizeBeforeCaller: {
        let x = 0;
        for (let i = 0; i < leftIndex; i++){
            x += leftElements[i];
        }
        return x;
    };
    property real calculatedleftMargin: defaultMargin + (leftElements[leftIndex]/2)  + leftSizeBeforeCaller  +(Config.rowSpacing * leftIndex)
    property bool isleftClamped: calculatedleftMargin < Config.margin/2; // True of the side of the popup is outside the margin
    // Right properties
    property int rightIndex: GlobalStates.rightPopupCallerIndex ?? 0; // Index of the right caller
    property var rightElements: GlobalStates.rightElementWidth ?? []; // The same array as rightElementWidth or an empty array
    property real rightSizeBeforeCaller: {
        let x = 0;
        for (let i = 0; i < rightIndex; i++){
            x += rightElements[i];
        }
        return x;
    };
    // def + half of caller + space before the caller (elements before the caller + (rowSpacing * caller index)) 
    property real calculatedRightMargin: defaultMargin + (rightElements[rightIndex]/2)  + rightSizeBeforeCaller  +(Config.rowSpacing * rightIndex)
    property bool isRightClamped: calculatedRightMargin < Config.margin/2; // True of the side of the popup is outside the margin
    
    margins.left: (isleftClamped) ? Config.margin/2 : calculatedleftMargin;
    margins.right: (isRightClamped) ? Config.margin/2 : calculatedRightMargin;

    // ANIMATION

    // Set initial opacity to 0 for fade-in effect
    contentItem.opacity: 0;
      
    // Animate opacity when window visibility changes
    Behavior on contentItem.opacity {
        NumberAnimation {
            duration: 150;
            easing.type: Easing.OutQuad;
        }
    }

    // Trigger fade-in when window becomes visible  
    onVisibleChanged: {
        if (visible) {
            contentItem.opacity = 1;
        } else {
            contentItem.opacity = 0;
        }  
    }
    color: "transparent";
    exclusiveZone: 0;

    ClippingRectangle {
        anchors.fill: parent;
        color: Colors.surface0;

        radius: 15;
        topLeftRadius: Config.popupTopRadius ? 15 : 0;
        topRightRadius: Config.popupTopRadius ? 15 : 0;
    }
}