import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets


ShellRoot{
    Component{
        id: workspaceComponent
        Workspace{}
    }
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


                Rectangle{
                    anchors.fill: parent;

                    color: Config.bgColor;
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
                        Row{ //left side
                            anchors.left: parent.left;  
                            anchors.right: wm.left;  
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
                        Rectangle{ // Workspaces panel
                            id: wm;
                            implicitHeight: parent.height;
                            implicitWidth: Widgets.middlePanelWidth;
                            anchors.centerIn: parent;
                            color: "transparent";
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