import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

PopupPos{
    implicitHeight: 150;
    implicitWidth: 200;
    Item{ // slider
        id: modeSlider;
        anchors.top: parent.top;
        width: parent.width;
        height: 35;
        Rectangle{
            id: sliderBase;
            anchors.centerIn: parent;
            width: parent.width - 25;
            height: parent.height - 20;
            radius: 20;
            color: Colors.surface0;
            Rectangle{
                id: slidingCircle;
                anchors.verticalCenter: parent.verticalCenter;
                width: 30; height: 30;
                radius: 10;
                color: Colors.overlay0;
                MouseArea{
                    anchors.fill: parent;
                    drag.target: slidingCircle;
                    drag.axis: Drag.XAxis;
                    drag.minimumX: 0;
                    drag.maximumX: PowerProfiles.hasPerformanceProfile ? sliderBase.width - slidingCircle.width : 112
                }
                onXChanged: {
                    if (x <= 40){
                        x = 0; 
                        PowerProfiles.profile = PowerProfile.PowerSaver;
                    } else if (x <= 112){
                        x = (parent.width - width) / 2;
                        PowerProfiles.profile = PowerProfile.Balanced;
                    } else if (x > 112 && PowerProfiles.hasPerformanceProfile){
                        x = parent.width - width
                        PowerProfiles.profile = PowerProfile.Performance;
                    }
                }
                Component.onCompleted: {
                    if (PowerProfiles.profile === PowerProfile.PowerSaver){
                        x = 0;
                    } else if (PowerProfiles.profile === PowerProfile.Balanced){
                        x = (parent.width - width) / 2;
                    } else if (PowerProfiles.profile === PowerProfile.Performance){
                        x = parent.width - width;
                    }
                }
            }
            Rectangle{ // ECO
                id: slideLeft;
                anchors.verticalCenter: parent.verticalCenter; anchors.left: parent.left;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.PowerSaver) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 5
                    source: "root:assets/icons/battery/eco";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: !(slidingCircle.x === 0); 
                    onClicked: slidingCircle.x = 0;
                }
            }
            Rectangle{ // BAL
                id: slideMid;
                anchors.verticalCenter: parent.verticalCenter; anchors.centerIn: parent;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.Balanced) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 10
                    source: "root:assets/icons/battery/balanced";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: !(slidingCircle.x === (sliderBase.width - slidingCircle.width) / 2); 
                    onClicked: slidingCircle.x = (sliderBase.width - slidingCircle.width) / 2;
                }
            }
            Rectangle{ // PERF
                id: slideRight;
                anchors.verticalCenter: parent.verticalCenter; anchors.right: parent.right;
                width: 28; height: 28;
                radius: 15; z: 1;
                color: (PowerProfiles.profile === PowerProfile.Performance) ? Colors.overlay0 : Colors.overlay1;
                IconImage{
                    anchors.centerIn: parent;
                    implicitSize: parent.height - 5
                    source: "root:assets/icons/battery/performance";
                }
                MouseArea{
                    anchors.fill: parent;
                    enabled: (!(slidingCircle.x === sliderBase.width - slidingCircle.width) && PowerProfiles.hasPerformanceProfile); 
                    onClicked: slidingCircle.x = sliderBase.width - slidingCircle.width;
                }
            }
        }
    }
    
}