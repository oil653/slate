import QtQuick
import Quickshell
import qs
import qs.components


PanelWindow{
    anchors{
        top: true;
        right: true;
        left: true;
    }
    implicitHeight: Config.height;
    color: "transparent";
    Rectangle{
        anchors.fill: parent;
        color: "grey";
        opacity: 0.6;
        radius: 15;
    }
}
