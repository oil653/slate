import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PopupPos{
    id: root;
    readonly property real defaultHeight: 200;
    property real notificationPanelHeight: 0;
    implicitHeight: defaultHeight + notificationPanelHeight; 
    implicitWidth: 250;
    Component.onCompleted: Notif.hasUnseen = false;
    Rectangle{
        anchors.fill: parent;
        radius: 15;
        topLeftRadius: Config.popupTopRadius ? 15 : 0;
        topRightRadius: Config.popupTopRadius ? 15 : 0;
        color: Colors.surface0;
        Rectangle{ // Top (control) panel
            id: controlPanel;
            anchors.top: parent.top;
            anchors.left: parent.left; anchors.right: parent.right;
            anchors.topMargin: 5; anchors.leftMargin: 5;
            implicitWidth: 40;
            Row{
                anchors.fill: parent;
                spacing: 5;
                ToggleIcon{ // Silent on off
                    implicitHeight: 40; implicitWidth: (parent.width-10) / 2; // -10 because of the two margin on the side
                    radius: 5;
                    onIcon: "root:assets/icons/bell_silent_on";
                    offIcon: "root:assets/icons/bell_silent_off";
                    isOn: Notif.isSilent;
                    onToggle: Notif.isSilent = isOn;
                }
                ButtonIcon{ // Delete all
                    implicitHeight: 40; implicitWidth: (parent.width-10) / 2;
                    radius: 5;
                    icon: "root:assets/icons/delete";
                    onPushed: Notif.removeAllNotification();
                }
            }
        }
    }
}