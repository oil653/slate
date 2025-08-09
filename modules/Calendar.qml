import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.modules

PanelWindow{
    id: root;

    anchors.top: true;
    // We anchor it to the side depending on the caller
    anchors.left: (GlobalStates.leftPopup === "") ? false : true;
    anchors.right: (GlobalStates.rightPopup === "") ? false : true;

    // Some overcomplicated calculations for the spacing
    property int leftCallerIndex: GlobalStates.leftPopupCallerIndex;
    property real leftCallerSize: GlobalStates.leftElementWidth[leftCallerIndex];
    property var leftElements: GlobalStates.leftElementWidth;
    property real leftSizeBeforeCaller: {
        let x = 0;
        for (let i = 0; i < leftCallerIndex; i++){
            x += leftElements[i];
        }
        return x;
    };
    margins.left: Config.margin + ((leftCallerSize/2)-implicitWidth/2) + leftSizeBeforeCaller + Config.rowSpacing*leftCallerIndex;

    property int rightCallerIndex: GlobalStates.rightPopupCallerIndex;
    property real rightCallerSize: GlobalStates.rightElementWidth[rightCallerIndex];
    property var rightElements: GlobalStates.rightElementWidth;
    property real rightSizeBeforeCaller: {
        let x = 0;
        for (let i = 0; i < rightCallerIndex; i++){
            x += rightElements[i];
        }
        return x;
    };
    margins.right: Config.margin + ((rightCallerSize/2)-implicitWidth/2) + rightSizeBeforeCaller + Config.rowSpacing*rightCallerIndex;

    implicitHeight: 100;
    implicitWidth: 100;
    exclusiveZone: 0;
    color: "transparent";
    Rectangle{
        anchors.fill: parent;
        radius: 10;
    }
}