import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PanelWindow{
    // popup positioning, can be used for any popup
    id: root;

    anchors.top: true;
    margins.top: 5;

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
    
    // Set initial state for both opacity and position  
    contentItem.opacity: 0;  
    contentItem.y: -200;  
    
    // Parallel animation for both opacity and slide-down  
    ParallelAnimation {  
        id: showAnimation  
        
        NumberAnimation {  
            target: root.contentItem  
            property: "opacity"  
            from: 0  
            to: 1  
            duration: 150  
            easing.type: Easing.OutQuad  
        }  
        
        NumberAnimation {  
            target: root.contentItem  
            property: "y"  
            from: -50
            to: 0  
            duration: 150  
            easing.type: Easing.OutQuad  
        }  
    }  
    
    // Trigger animations when window becomes visible  
    onVisibleChanged: {  
        if (visible) {  
            showAnimation.start();  
        } else {  
            contentItem.opacity = 0;  
            contentItem.y = -200;  
        }  
    }

    color: "transparent";
    exclusiveZone: 0;

    Rectangle {
        id: background
        anchors.fill: parent;
        color: Colors.background;
        radius: 15;
        opacity: 0.9;
    }

    Loader{
        active: Config.closeOnOutclick;
        sourceComponent: panelLoader;
    }

    Component{
        id: panelLoader
        Variants{
            model: Quickshell.screens;
            delegate: Component{
                PanelWindow{
                    required property var modelData;
                    screen: modelData;
                    anchors{
                        top: true;
                        bottom: true;
                        left: true;
                        right: true;
                    }
                    color: "transparent";
                    exclusiveZone: 0;
                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            GlobalStates.leftPopup = "";
                            GlobalStates.rightPopup = "";
                            GlobalStates.middlePopup = "";
                        }
                    }
                }
            }
        }
    }
}