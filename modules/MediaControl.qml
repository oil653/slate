//@ pragma UseQApplication

import QtQuick
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules


// It doesnt have the PopupPos because i want to use this in the home panel as a widget.

Rectangle{
    id: rootrect;
    anchors.fill: parent;
    color: Colors.surface0;

    
    radius: 15;
    topLeftRadius: Config.popupTopRadius ? 15 : 0;
    topRightRadius: Config.popupTopRadius ? 15 : 0;

    property real leftWidth: 2*(rootRect.width) - seperator; 
    property real seperator: 5

    function formatTime(seconds) {  
        const hours = Math.floor(seconds / 3600);
        const minutes = Math.floor((seconds % 3600) / 60);
        const secs = Math.floor(seconds % 60);
        
        if (hours > 0) {
            return `${hours}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
        } else {
            return `${minutes}:${secs.toString().padStart(2, '0')}`;
        }
    }

    ClippingRectangle{ // Need the clipping rect for the radius
        id: rootRect;
        anchors.left: parent.left;
        anchors.bottom: parent.bottom;
        implicitWidth: parent.height;
        implicitHeight: parent.height;
        topLeftRadius: Config.popupTopRadius ? 15 : 0;
        bottomLeftRadius: 15;
        color: rootrect.color;
        IconImage{
            anchors.fill: parent;
            source: MediaController.activePlayer.trackArtUrl || "root:assets/icons/question_mark";
            implicitSize: parent.height;
        }
    }
    SlidingText{ // title
        id: trackTitle;
        anchors.left: rootRect.right; anchors.leftMargin: parent.seperator;
        anchors.top: parent.top; anchors.topMargin: 4;
        text: MediaController.activeTrack.title;
        fontSize: 18;
        height: 33;
        width: parent.leftWidth;
    }
    SlidingText{ // artist --- album
        id: trackArtist;
        anchors.left: rootRect.right; anchors.leftMargin: parent.seperator;
        anchors.top: trackTitle.bottom;
        
        text: (MediaController.activeTrack.album === "") ? `${MediaController.activeTrack.artist}` : `${MediaController.activeTrack.artist} - ${MediaController.activeTrack.album}`;
        fontSize: 8;
        height: 15;
        width: parent.leftWidth;
    }   
    Rectangle{ // Player selector
        id: playerSelector;
        anchors.right: parent.right; anchors.rightMargin: parent.seperator;
        anchors.top: trackArtist.bottom; anchors.topMargin: parent.seperator;
        height: 30; width: 100; radius: 20;
        color: Colors.overlay1;
        Text{
            anchors.fill: parent; anchors.margins: 5;
            anchors.centerIn: parent;
            horizontalAlignment: Text.AlignHCenter;
            text: MediaController.activePlayer.identity;
            color: Colors.text;
            font.weight: 600;
            font.pointSize: 12;
            MouseArea{
                anchors.fill: parent;
                    acceptedButtons: Qt.LeftButton | Qt.RightButton;
                onClicked: playerDropdown.open();
            } 
        }
        Menu{ // This menu looks absolutely ASS, should be reworked with a popup or something
            id: playerDropdown;
            width: parent.width;
            Repeater{
                model: Mpris.players;
                delegate: MenuItem{
                    property var data: modelData;
                    text: data.identity;
                    onTriggered: MediaController.setActivePlayer(data);
                }
            }
        }
    }
    Row{ // Music control row
        id: controlLayout;
        visible: MediaController.activePlayer.canControl;
        anchors.top: trackArtist.bottom; anchors.topMargin: 5;
        anchors.left: rootRect.right; anchors.leftMargin: 5;
        spacing: 0;
        width: parent.leftWidth; height: 30;
        IconImage{ // previous
            visible: MediaController.activePlayer.canGoPrevious;
            source: "root:assets/icons/skip_previous";
            implicitSize: parent.height;
            MouseArea{
                anchors.fill: parent;
                onClicked: MediaController.activePlayer.previous();
            }
        }
        IconImage{ // play
            source: (MediaController.activePlayer.isPlaying) ? "root:assets/icons/pause" : "root:assets/icons/play_pause" ;
            implicitSize: parent.height;
            MouseArea{
                anchors.fill: parent;
                onClicked: MediaController.activePlayer.isPlaying = !MediaController.activePlayer.isPlaying; 
            }
        }
        IconImage{ // next
            visible: MediaController.activePlayer.canGoNext;
            source: "root:assets/icons/skip_next";
            implicitSize: parent.height;
            MouseArea{
                anchors.fill: parent;
                onClicked: MediaController.activePlayer.next();
            }
        }
        IconImage{ // shuffle
            visible: MediaController.activePlayer.shuffleSupported;
            source: (MediaController.activePlayer.shuffle) ? "root:assets/icons/shuffle_on" : "root:assets/icons/shuffle";
            implicitSize: parent.height -2; anchors.verticalCenter: parent.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: MediaController.activePlayer.shuffle = !MediaController.activePlayer.shuffle
            }
        }
        IconImage{ // repeat
            visible: MediaController.activePlayer.loopSupported;
            property var loopState: MediaController.activePlayer.loopState ?? null; // Shorter name, better readability
            source: (loopState == MprisLoopState.None) ? "root:assets/icons/repeat" 
                : (loopState == MprisLoopState.Track) ? "root:assets/icons/repeat_one"
                : (loopState == MprisLoopState.Playlist) ? "root:assets/icons/repeat_on" : "";
            implicitSize: parent.height -2; anchors.verticalCenter: parent.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    var nextState = (parent.loopState == MprisLoopState.None) ? MprisLoopState.Track
                        : (parent.loopState == MprisLoopState.Track) ? MprisLoopState.Playlist
                        : MprisLoopState.None;
                    MediaController.activePlayer.loopState = nextState;
                }
            }
        }
    }
    Item{
        id: timeBar;
        anchors.top: controlLayout.bottom; anchors.topMargin: 10;
        anchors.left: rootRect.right; anchors.leftMargin: 5;
        height: 20; width: parent.leftWidth;
        property int pos: MediaController.activePlayer.position;
        property int len: MediaController.activePlayer.length;
        Row{
            anchors.fill: parent;
            spacing: 4;
            Text{
                id: timeStamp;
                anchors.verticalCenter: parent.verticalCenter;
                width: 40;
                color: Colors.text;
                text: `${rootrect.formatTime(timeBar.pos)}`;

            }
            Rectangle{
                id: slider;
                visible: MediaController.activePlayer.positionSupported;
                width: parent.width - 2 * timeStamp.width - 15; // 170
                height: 10; radius: 20
                anchors.verticalCenter: parent.verticalCenter;
                color: Colors.overlay1;
                Rectangle{
                    id: currentTimeRect;
                    anchors.verticalCenter: parent.verticalCenter;
                    height: parent.height; radius: 20;
                    x: 0; color: Colors.overlay0;
                    width: timeBar.len > 0 ? (timeBar.pos / timeBar.len) * parent.width : 0;
                }
                MouseArea {  
                    anchors.fill: parent;
                    onClicked: {
                        if (MediaController.activePlayer.canSeek){
                            if (MediaController.activePlayer && MediaController.activePlayer.positionSupported) {
                                var relativePosition = mouseX / parent.width;
                                var newPositionSeconds = relativePosition * MediaController.activePlayer.length;
                                MediaController.activePlayer.position = newPositionSeconds;
                            }
                        }
                    }
                }
            }
            Text{
                id: timeRemaining;
                anchors.verticalCenter: parent.verticalCenter;
                width: 40;
                text: `${rootrect.formatTime(timeBar.len - timeBar.pos)}`;
                color: Colors.text;
            }
        }
    }
}
