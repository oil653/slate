pragma Singleton
import QtQuick
import Quickshell

Singleton{
    property string leftPopup: ""; // Its either an empty string or the name of the caller of the popup. So popup for clock is clock...
    property bool leftPopupAnchor: false; // This should be true when the component is the first in the list and should be anchored to the side of the screen

    property string rightPopup: "";
    property bool rightPopupAnchor: false;


    property string middlePopup: "";
}