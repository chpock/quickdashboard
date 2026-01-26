pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property real secondsCount: dateSeconds.getTime() / 1000
    // readonly property alias seconds: clockSeconds.seconds
    readonly property alias dateSeconds: clockSeconds.date

    // readonly property alias minutes: clockMinutes.minutes
    readonly property alias minutesCount: clockMinutes.minutesCount
    readonly property alias dateMinutes: clockMinutes.date

    // readonly property alias hours: clockHours.hours
    readonly property alias hoursCount: clockHours.hoursCount
    readonly property alias dateHours: clockHours.date

    readonly property alias daysCount: clockDays.daysCount
    readonly property alias dateDays: clockDays.date

    SystemClock {
        id: clockSeconds
        precision: SystemClock.Seconds
    }

    QtObject {
        id: clockMinutes
        property date date: new Date()
        // property int minutes: date.getMinutes()
        property real minutesCount: Math.floor(date.getTime() / 60000)
    }

    QtObject {
        id: clockHours
        property date date: new Date()
        // property int hours: date.getHours()
        property real hoursCount: Math.floor(date.getTime() / 3600000)
    }

    QtObject {
        id: clockDays
        property date date: new Date()
        property real daysCount: Math.floor(date.getTime() / 86400000)
    }

    onDateSecondsChanged: {
        const secondsCount = Math.floor(dateSeconds.getTime() / 1000)
        if (Math.floor(secondsCount / 60) !== clockMinutes.minutesCount) {
            clockMinutes.date = dateSeconds
            if (Math.floor(secondsCount / 3600) !== clockHours.hoursCount) {
                clockHours.date = dateSeconds
                if (Math.floor(secondsCount / 86400) !== clockDays.daysCount) {
                    clockDays.date = dateSeconds
                }
            }
        }
    }
}
