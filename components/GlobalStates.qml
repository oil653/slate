pragma Singleton
import QtQuick
import Quickshell

Singleton{
    property string leftPopup: ""; // Its either an empty string or the name of the caller of the popup. So popup for clock is clock...
    property var leftElementWidth: []; // A list of the width propeties of all panel on the left panel
    property int leftPopupCallerIndex; // and index of which module called the popup on the left panel 

    property string rightPopup: "";
    property var rightElementWidth: [];
    property int rightPopupCallerIndex;


    property string middlePopup: "";

    function globalStatesContain(panelName: string): bool {
        return (GlobalStates.leftPopup === panelName || GlobalStates.rightPopup === panelName || GlobalStates.middlePopup === panelName);
    }
}