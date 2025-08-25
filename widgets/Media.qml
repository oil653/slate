import QtQuick
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

Item{
    id: root;
    implicitHeight: Config.height - Config.widgetHeight;
    implicitWidth: 200;
    Row{
        anchors.fill: parent;
        anchors.verticalCenter: parent.verticalCenter;
        CircleMediaBar{
            visible: MediaController.activePlayer.positionSupported; 
            length: MediaController.activePlayer.length ?? 0;
            timestamp: MediaController.activePlayer.position ?? 0;
            IconImage{
                visible: MediaController.activePlayer.canPause ?? false;
                anchors.centerIn: parent
                source: !(MediaController.activePlayer.isPlaying) ? "root:assets/icons/play": "root:assets/icons/pause";
                implicitSize: 20;
                MouseArea{
                    anchors.fill: parent;
                    onClicked: {
                        MediaController.activePlayer.isPlaying = (!MediaController.activePlayer.isPlaying);
                    }
                }
            }  
        }
        Item{width: 5; height: parent.height} // spacer
        SlidingText{
            text: `${MediaController.activePlayer.trackArtist} <b>·</b> ${MediaController.activePlayer.trackTitle}`;
            fontSize: Config.height / 2 - 2;
            height: parent.height;
            width: parent.width - Config.height;
        }
    }
}