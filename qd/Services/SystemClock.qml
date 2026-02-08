/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
