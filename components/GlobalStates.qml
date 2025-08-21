pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton{
    id: globalStates;
    property string leftPopup: ""; // Its either an empty string or the name of the caller of the popup. So popup for clock is clock...
    property var leftElementWidth: []; // A list of the width propeties of all panel on the left panel
    property int leftPopupCallerIndex; // and index of which module called the popup on the left panel 

    property string rightPopup: "";
    property var rightElementWidth: [];
    property int rightPopupCallerIndex;


    property string middlePopup: "";

    property int selectedKybIndex: 0; // The index of the selected keyboard in Config.keyboard 

    onSelectedKybIndexChanged: Swayctl.kybSwitch(Config.keyboard[selectedKybIndex].layout, Config.keyboard[selectedKybIndex].variant);

    function globalStatesContain(panelName: string): bool {
        return (GlobalStates.leftPopup === panelName || GlobalStates.rightPopup === panelName || GlobalStates.middlePopup === panelName);
    }

    IpcHandler{
        target: "globalStates";
        
        function cycleKyb(){
            if (selectedKybIndex + 1 > Config.keyboard.length -1){
                selectedKybIndex = 0;
            } else{
                selectedKybIndex += 1;
            }
        }
    }
}