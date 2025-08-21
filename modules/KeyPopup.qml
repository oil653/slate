import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.modules
import qs.services

PopupPos{
    id: root;
    implicitHeight: rep.count * 25 + (rep.count-1) * 2;
    implicitWidth: 120;
    property int margin;
    Column{
        anchors.centerIn: parent;
        spacing: 2
        Repeater{
            id: rep;
            model: ScriptModel{
                values:[...Config.keyboard]
            }
            Rectangle{
                required property var modelData;
                required property int index;

                width: root.width - 2*margin;
                height: 25;
                color: GlobalStates.selectedKybIndex === index ? Colors.overlay0 : Colors.overlay1;

                property bool isLast: index === rep.count -1;
                topLeftRadius: (Config.popupTopRadius & index === 0) ? 15 : 0;
                topRightRadius: (Config.popupTopRadius & index === 0) ? 15 : 0;

                bottomLeftRadius: isLast ? 15 : 0;
                bottomRightRadius: isLast ? 15 : 0;
                Text{
                    anchors.centerIn: parent;
                    text: `${modelData.layout} - ${parent.modelData.variant}`
                    font.pixelSize: 15;
                    color: Colors.text2;
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked:{
                        Swayctl.kybSwitch(modelData.layout, modelData.variant);
                        GlobalStates.selectedKybIndex= parent.index;
                        cursorShape: Qt.PointingHandCursor; 
                    }
                }
            }
        }
    }
}