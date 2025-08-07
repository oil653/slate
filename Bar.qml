import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets


ShellRoot{
    Variants{
        model: Quickshell.screens;
        delegate: Component{
            PanelWindow{
                id: panelRoot;
                property var modelData: modelData;
                screen: modelData;
                anchors.top: true;

                implicitWidth: modelData.width - Config.margin;
                implicitHeight: Config.height;
                color: "transparent";


                Component{
                    id: workspaceLoader;
                    Workspace{
                        implicitWidth: 100;
                        implicitHeight: Config.height -2;
                        currentMonitor: (Config.isWorkspacesPerMonitor) ? panelRoot.modelData.name : "";
                    }
                }
                Rectangle{
                    anchors.fill: parent;

                    color: Colors.background;
                    opacity: Config.opacity;

                    topLeftRadius: Config.radius;
                    topRightRadius: Config.radius;
                    bottomLeftRadius: Config.bottomRadius ? Config.radius : 0;
                    bottomRightRadius: Config.bottomRadius ? Config.radius : 0;

                    Item{
                        id: widgetLayout;
                        anchors.fill: parent;
                        anchors.leftMargin: Config.radius;
                        anchors.rightMargin: Config.radius;
                        property real maxItemWidth: ((this.width - (2* Config.radius)) / 10) - Widgets.middlePanelWidth;
                        Item{
                            id:wl1;
                            implicitHeight: parent.height;
                            anchors.left: widgetLayout.left;
                            property string config: Widgets.wl1;
                            Loader{
                                id: loader;
                                anchors.centerIn: parent;
                                active: true;
                                sourceComponent: {
                                    switch (wl1.config){
                                        case "workspace":
                                            return workspaceLoader;
                                        default:
                                            return null;
                                    }
                                }
                                onLoaded: {
                                    if (item) wl1.implicitWidth = item.implicitWidth;
                                    else wl1.implicitWidth = 0;
                                }
                            }
                        }
                        Item{ // Middle panel
                            id: wm;
                            implicitHeight: parent.height - 2; // leaves some space between the top and the bottom of the bar and this
                            implicitWidth: Widgets.middlePanelWidth;
                            anchors.centerIn: parent;
                            Workspace{
                                anchors.fill: parent;
                                currentMonitor: panelRoot.modelData.name;
                            }
                        }
                        Row{ //right side
                            anchors.left: wm.right;
                            anchors.right: parent.right; 
                            anchors.verticalCenter: parent.verticalCenter 
                            Repeater{
                                model: 5;
                                WrapperRectangle {  
                                    color: "white";  
                                    implicitWidth: Math.min(child ? child.implicitWidth : 0, widgetLayout.maxItemWidth)  
                                    implicitHeight: widgetLayout.height;
                                }  
                            }
                        }
                    }
                }
            }
        }
    }
}