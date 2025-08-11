import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.services
import qs.modules

Item {
    id: root
    required property string text;
    required property real fontSize;
    property string textColor: Colors.text;
    required height;
    required width;
    Rectangle {
        id: cropper;
        anchors.fill: parent;
        color: "transparent";
        clip: true;

        Text {
            id: slidingText;
            color: root.textColor;
            text: root.text;
            font.pointSize: root.fontSize;
            // anchors.verticalCenter: parent.verticalCenter;
            anchors.top: parent.top;
            wrapMode: Text.NoWrap;
            property bool shouldSlide: (contentWidth > cropper.width);
            onShouldSlideChanged: x = 0;

            SequentialAnimation {  
                id: slideAnimation;
                running: slidingText.shouldSlide;
                loops: Animation.Infinite;
                
                // anim1: slide from 0 to -contentWidth  
                NumberAnimation {
                    target: slidingText;
                    property: "x";
                    from: 0;
                    to: -slidingText.contentWidth;
                    duration: 4000;
                    easing.type: Easing.InQuad;
                }  
                
                // Instant jump to contentWidth (no animation)  
                ScriptAction {
                    script: slidingText.x = cropper.width;
                }
                
                // anim2: slide from contentWidth to 0  
                NumberAnimation {
                    target: slidingText;
                    property: "x";
                    from: slidingText.contentWidth;
                    to: 0;
                    duration: 4000;
                    easing.type: Easing.OutQuad;
                }  
                PauseAnimation {
                    duration: 4000;
                }  
            }  
        }
    }
}