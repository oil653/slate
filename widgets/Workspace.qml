import QtQuick
import QtQuick.Layouts
import Quickshell.I3
import Quickshell.Widgets
import Quickshell
import qs.components

// Widget for Sway and I3 worspaces
// There is no internal positioning, have to be positioned from the caller


Rectangle{
    id: root;
    color: "Transparent";
    property string currentMonitor: ""; // The caller could pass the current monitor for sorting of the workspaces by monitor

    FontLoader{
        id: icelandFont;
        source: "root:/assets/fonts/Iceland-Regular.ttf"
    }
    Rectangle{
        id: bg;
        anchors.centerIn: parent;
        width: row.implicitWidth;
        height: Config.height;
        radius: 15;
        opacity: 1;
        color: "#565454";
        Row{
            id: row;
            anchors.centerIn: parent;
            Repeater{
                model: {
                    if (!currentMonitor) return I3.workspaces;
                    return I3.workspaces.values.filter(workspace =>   
                        workspace.monitor && workspace.monitor.name === currentMonitor  
                    );  
                }
                Rectangle{
                    id: workspace;
                    property var model: modelData;
                    width: root.height;
                    height: root.height;
                    radius: 15;
                    color: bg.color;
                    Text{
                        anchors.centerIn: parent;
                        text: workspace.model.name;
                        font.pointSize: parent.height - 5;
                        font.family: icelandFont.name;
                    }
                }
            }
        }
    }
}