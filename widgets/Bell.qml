import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

// Notification widget
Item{
    id: root;
    implicitWidth: implicitHeight;
    IconImage{
        id: icon;
        implicitSize: parent.height;
        source: (Notif.hasUnseen) ? "root:assets/icons/bell_unread" :"root:assets/icons/bell"
        MouseArea{
            anchors.fill: parent;
            acceptedButtons: Qt.RightButton;
            onClicked: Notif.hasUnseen= false;
        }
    }
}