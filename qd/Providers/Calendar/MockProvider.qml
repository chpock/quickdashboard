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

import QtQuick
import qs.qd.Providers as Providers

Provider {
    id: root

    running: true
    hasService: false
    calendarApplicationAvailable: true

    calendarColors: ({
        'devops@group.calendar.google.com': 0,
        'meeting@group.calendar.google.com': 4,
        'personal@group.calendar.google.com': 6,
    })

    readonly property var _eventsAll: [
        {
            calendarId: 'devops@group.calendar.google.com',
            title: "Deploy to Prod (Fingers X'd)",
            start: '-7m14s',
            duration: '30m',
        },
        {
            calendarId: 'work@group.calendar.google.com',
            title: 'Demo: It works on my machine',
            start: '9m16s',
            duration: '10m',
        },
        {
            calendarId: 'meeting@group.calendar.google.com',
            title: '1:1 Sync (Emotional Support)',
            start: '2h10m',
            duration: '1h10m',
        },
        {
            calendarId: 'work@group.calendar.google.com',
            title: 'Planning: Pure Guesswork',
            start: '5h34m',
            duration: '1h5m10s',
        },
        {
            calendarId: 'personal@group.calendar.google.com',
            title: 'Lunch (AFK / Do Not Disturb)',
            start: '10h1m',
            duration: '1h',
        },
        {
            calendarId: 'work@group.calendar.google.com',
            title: "Daily Standup: Nodding until it's my turn",
            start: '26h47m',
            duration: '16m10s',
        },
        {
            calendarId: 'devops@group.calendar.google.com',
            title: 'Release: v2.0 (Maybe)',
            start: '27h1m',
            duration: '3h10m',
        },
        {
            calendarId: 'meeting@group.calendar.google.com',
            title: 'Client Sync (Smile & Nod)',
            start: '28h3m',
            duration: '10m5s',
        },
    ]

    eventsAll: _eventsAll.map(item => {
        const startOffset = parseDuration(item.start)
        const endOffset = startOffset + parseDuration(item.duration)
        return {
            calendarId: item.calendarId,
            eventId: Qt.md5(item.title + startOffset),
            title: item.title,
            start: getDateWithOffset(startOffset),
            end: getDateWithOffset(endOffset),
        }
    })

    function parseDuration(value: string): int {
        const isNegative = value.startsWith("-")

        const hoursMatch = value.match(/(\d+)h/)
        const minutesMatch = value.match(/(\d+)m/)
        const secondsMatch = value.match(/(\d+)s/)

        const hours = hoursMatch ? parseInt(hoursMatch[1]) : 0
        const minutes = minutesMatch ? parseInt(minutesMatch[1]) : 0
        const seconds = secondsMatch ? parseInt(secondsMatch[1]) : 0

        const totalSeconds = (hours * 3600) + (minutes * 60) + seconds

        return isNegative ? -totalSeconds : totalSeconds;
    }

    function getDateWithOffset(offset: int): date {
        // qmllint disable missing-property
        const calcDate = Providers.SystemClock.instance.dateSeconds.getTime() + offset * 1000
        // qmllint enable missing-property
        return new Date(calcDate)
    }

    Component.onCompleted: {
        Qt.callLater(() => {
            root.updateModels()
        })
    }

}
