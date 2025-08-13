pragma Singleton

import Quickshell

Singleton {
    readonly property date date: clock.date;
    readonly property int hours: clock.hours;
    readonly property int minutes: clock.minutes;
    readonly property int seconds: clock.seconds;

    SystemClock {
        id: clock;
        precision: SystemClock.Seconds;
    }
}