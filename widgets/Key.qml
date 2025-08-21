import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets

Item {
    id: root;

    implicitWidth: wrapper.width + 2;
    implicitHeight: Config.height;
    // Rectangle{anchors.fill: parent; color: "grey";}
    WrapperRectangle{
        id: wrapper;
        anchors.centerIn: parent;
        color: "transparent"
        Text{
            anchors.centerIn: parent;
            text: `${Config.keyboard[GlobalStates.selectedKybIndex].layout}\n${Config.keyboard[GlobalStates.selectedKybIndex].variant}`
            color: Colors.text;
            horizontalAlignment: Text.AlignHCenter;
            lineHeight: 0.8
        }
    }
}
