import QtQuick
import Quickshell.Widgets
import Quickshell
import qs
import qs.components
import qs.widgets
import qs.modules

PopupPos{
    id: root;
    implicitHeight: 250;
    implicitWidth: 250;
    
    property date today: new Date();
    property int displayedMonth: today.getMonth();
    property int displayedYear: today.getFullYear();

    property var monthNames: [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];

    Item { // Header with nav
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.topMargin: 5;
        height: 20;

        Item { // -1 month
            id: prevButton;
            width: 20; height: 20;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.right: currentMonth.left;

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    if (root.displayedMonth === 0) {
                        root.displayedMonth = 11
                        root.displayedYear -= 1
                    } else {
                        root.displayedMonth -= 1
                    }
                }
            }
            IconImage{
                anchors.centerIn: parent;
                source: "root:assets/icons/arrow_back.svg";
                implicitSize: 18;
            }
        }

        Text {
            id: currentMonth;
            anchors.centerIn: parent;
            text: root.monthNames[root.displayedMonth] + " " + root.displayedYear
            color: Colors.text;
            font.pixelSize: 18
            font.bold: true;
            horizontalAlignment: Text.AlignHCenter
        }

        Item { // +1 month
            id: nextButton;
            width: 20; height: 20;
            anchors.verticalCenter: parent.verticalCenter;
            anchors.left: currentMonth.right;

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    if (root.displayedMonth === 11) {
                        root.displayedMonth = 0
                        root.displayedYear += 1
                    } else {
                        root.displayedMonth += 1
                    }
                }
            }
            IconImage{
                anchors.centerIn: parent;
                source: "root:assets/icons/arrow_forward.svg";
                implicitSize: 18;
            }
        }
    }

    // Days of week header
    Row {
        id: daysOfWeekRow;
        anchors.top: parent.top;
        anchors.topMargin: 35;
        anchors.horizontalCenter: parent.horizontalCenter;
        spacing: 0;
        Repeater {
            model: ["M", "T", "W", "T", "F", "s", "S"];
            Text {
                width: 34;
                height: 24;
                text: modelData;
                color: Colors.overlay0;
                font.pixelSize: 14;
                font.weight: Font.Medium;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
            }
        }
    }

    // Calendar grid
    Grid {
        id: calendarGrid;
        anchors.top: daysOfWeekRow.bottom;
        anchors.topMargin: 0;
        anchors.horizontalCenter: parent.horizontalCenter;
        columns: 7;
        rowSpacing: 4;
        columnSpacing: 0;

        property int firstDayOfMonth: {
            // JavaScript Date: 0=Sunday, 6=Saturday. We want Monday=0.
            var d = new Date(root.displayedYear, root.displayedMonth, 1)
            var day = d.getDay()
            return (day + 6) % 7 // shift so Monday=0
        }
        property int daysInMonth: {
            var d = new Date(root.displayedYear, root.displayedMonth + 1, 0)
            return d.getDate()
        }
        property int prevMonthDays: {
            var d = new Date(root.displayedYear, root.displayedMonth, 0)
            return d.getDate()
        }

        Repeater {
            id: calendarRepeater
            model: {
                // How many cells: firstDayOfMonth + daysInMonth + fill to full week
                let total = calendarGrid.firstDayOfMonth + calendarGrid.daysInMonth
                return total + (7 - (total % 7 === 0 ? 7 : total % 7))
            }
            Rectangle {
                width: 34; height: 34
                color: {
                    // Highlight today
                    var cellDay = index - calendarGrid.firstDayOfMonth + 1
                    if (index < calendarGrid.firstDayOfMonth) {
                        "transparent"
                    } else if (cellDay === root.today.getDate()
                            && root.displayedMonth === root.today.getMonth()
                            && root.displayedYear === root.today.getFullYear()) {
                        Colors.background
                    } else {
                        "transparent"
                    }
                }
                radius: 20
                border.color: "transparent"

                Text {
                    anchors.centerIn: parent
                    text: {
                        // Show date number or blank
                        if (index < calendarGrid.firstDayOfMonth) {
                            // previous month's days, faded
                            var prevDay = calendarGrid.prevMonthDays - calendarGrid.firstDayOfMonth + index + 1
                            return prevDay > 0 ? prevDay : ""
                        }
                        var day = index - calendarGrid.firstDayOfMonth + 1
                        return (day > 0 && day <= calendarGrid.daysInMonth) ? day : ""
                    }
                    color: {
                        if (index < calendarGrid.firstDayOfMonth) {
                            Colors.text2
                        } else if (index - calendarGrid.firstDayOfMonth + 1 === root.today.getDate()
                            && root.displayedMonth === root.today.getMonth()
                            && root.displayedYear === root.today.getFullYear()) {
                            Colors.text
                        } else {
                            Colors.overlay0
                        }
                    }
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }
                opacity: {
                    if (index < calendarGrid.firstDayOfMonth) 0.3
                    else 1
                }
            }
        }
    }
}
