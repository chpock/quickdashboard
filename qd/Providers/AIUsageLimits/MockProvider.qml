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

    hasService: false

    readonly property var _providers_data: [
        {
            id: "codex",
            displayName: "Codex",
            plan: "Plus",
            lines: [
                {
                    label: "Session",
                    periodDurationSeconds: 18000,
                    percent: 0.78,
                    resetsAt: "1h37m",
                },
                {
                    label: "Weekly",
                    periodDurationSeconds: 604800,
                    percent: 0.2,
                    resetsAt: "1d15h",
                }
            ],
            error: '',
        },
        {
            id: "gemini",
            displayName: "Gemini",
            plan: '',
            lines: [],
            error: "Gemini session expired. Run `gemini auth login` to authenticate.",
        },
        {
            id: "opencode-go",
            displayName: "OpenCode Go",
            plan: "Go",
            lines: [
                {
                    label: "Session",
                    periodDurationSeconds: 18000,
                    percent: 0.91,
                    resetsAt: "9m5s",
                },
                {
                    label: "Weekly",
                    periodDurationSeconds: 604800,
                    percent: 0.37,
                    resetsAt: "8h13m",
                },
                {
                    label: "Monthly",
                    periodDurationSeconds: 2592000,
                    percent: 0.57100000000000003,
                    resetsAt: "1d5h",
                }
            ],
            error: '',
        },
    ]

    function parseDuration(value: string): int {
        const isNegative = value.startsWith("-")

        const daysMatch = value.match(/(\d+)d/)
        const hoursMatch = value.match(/(\d+)h/)
        const minutesMatch = value.match(/(\d+)m/)
        const secondsMatch = value.match(/(\d+)s/)

        const days = daysMatch ? parseInt(daysMatch[1]) : 0
        const hours = hoursMatch ? parseInt(hoursMatch[1]) : 0
        const minutes = minutesMatch ? parseInt(minutesMatch[1]) : 0
        const seconds = secondsMatch ? parseInt(secondsMatch[1]) : 0

        const totalSeconds = (days * 86400) + (hours * 3600) + (minutes * 60) + seconds

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
            const providers_data = root._providers_data.map(item => Object.assign({}, item, {
                lines: item.lines.map(item => Object.assign({}, item, {
                    resetsAt: root.getDateWithOffset(parseDuration(item.resetsAt)),
                }))
            }))

            for (const item of providers_data) {
                root.providersModel.append(item)
            }
        })
    }
}
