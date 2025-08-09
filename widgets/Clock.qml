import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets

Item {
    id: root;

    SystemClock {
        id: clock;
        precision: SystemClock.Seconds;
    }

    property date selectedDate: clock.date;
    implicitWidth: wrapper.implicitWidth;

    WrapperRectangle {
        id: wrapper
        anchors.centerIn: parent;
        color: "transparent";

        Text {
            id: dateLabel;
            text: Qt.formatDateTime(root.selectedDate, Config.dateFormat);
            font.pointSize: 12;
            color: Colors.text;
        }
    }
}
