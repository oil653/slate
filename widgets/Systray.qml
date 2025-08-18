import QtQuick
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

Item{
    id: root;
    implicitWidth: wrapper.width;
    WrapperItem{
        id: wrapper
        anchors.centerIn: parent;
        Row{
            spacing: 2;
            Repeater{
                id: rep;
                model: Tray.list;
                Rectangle{
                    required property var modelData;
                    property bool isCritical: modelData.status === 2;
                    property bool isPassive: modelData.status === 0;

                    visible: isPassive;
                    height: root.height;
                    width: root.height;
                    radius: 20;
                    color: isCritical ? Colors.red : "transparent";
                    IconImage{
                        anchors.centerIn: parent;
                        source: modelData.icon;
                        implicitSize: parent.height - 5;
                    }
                    MouseArea{ // main
                        anchors.fill: parent;
                        property bool hasActivate: !modelData.onlyMenu;
                        cursorShape: hasActivate ? Qt.PointingHandCursor : Qt.ArrowCursor;
                        onClicked: if(hasActivate){modelData.activate}
                    }
                    MouseArea{ // secondary
                        anchors.fill: parent;
                        property bool hasSecActivate: !modelData.onlyMenu;
                        acceptedButtons: Qt.MiddleButton;
                        cursorShape: hasSecActivate ? Qt.PointingHandCursor : Qt.ArrowCursor;
                        onClicked: if(hasSecActivate){modelData.secondaryActivate}
                    }
                    MouseArea{ // menu
                        anchors.fill: parent;
                        property bool hasMenu: modelData.hasMenu;
                        acceptedButtons: Qt.RightButton;
                        onClicked: if(hasMenu){modelData.display(QsWindow.window, 0, root.height)}
                    }
                }
            }
        }
    }    
}