import QtQuick
import QtQuick.Layouts

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

Scope {
    id: root;

    PwObjectTracker { 
        objects: [Pipewire.defaultAudioSink];
    }

    Connections{
        target: Pipewire.defaultAudioSink?.audio;
        
        function onVolumeChanged() {
            root.osdRequested = true;
            hideTimer.restart();
        }
    }

    property bool osdRequested: false;

    Timer{
        id: hideTimer;
        interval: 1500; // ms
        onTriggered: root.osdRequested = false;
    }


    LazyLoader{
        active: root.osdRequested;

        PanelWindow{
            implicitHeight: screen.height / 25;
            implicitWidth: screen.width / 7;
            exclusiveZone: 0;

            anchors.bottom: true;
            margins.bottom: screen.height / 9;

            color: "transparent";

            // Masks the whole window so it doesnt block mouse events
            mask: Region{}

            Rectangle{
                anchors.fill: parent;
                radius: height / 2;
                color: "black";
                
                RowLayout{
                    anchors {
                        fill: parent;
                        leftMargin: 10;
                        rightMargin: 15;
                    }

                    IconImage {
                        implicitSize: 30;
                        source: "root:assets/icons/devices/other_audio";
                    }

                    Rectangle{
                        Layout.fillWidth: true;

                        implicitHeight: 10;
                        radius: 20;
                        color: "#50ffffff";

                        Rectangle{
                            anchors {
                                left: parent.left;
                                top: parent.top;
                                bottom: parent.bottom;
                            }
                            color: "white";
                            implicitWidth: parent.width * (Pipewire.defaultAudioSink?.audio.volume ?? 0);
                            radius: parent.radius;
                        }
                    }
                }
            }
        }
    }
}
