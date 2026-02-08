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
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    signal updateListGateway(var data)

    property var gatewaysList: []

    property int gwListRefreshInterval: 10000

    Timer {
        id: gwListsStartupTimer
        interval: 500
        running: true
        repeat: false
        onTriggered: gwListProc.running = true
    }

    Process {
        id: gwListProc
        property var gatewaysList: []
        property bool updateRequired: false
        command: ['ip', 'route', 'show', 'default']
        running: false
        stderr: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                console.warn('[Services/Ip@gwListProc]', '[ip stderr]', line)
            }
        }
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: line => {
                const parts = line.split(' ')
                if (parts.length < 3 || parts[0] !== 'default' || parts[1] !== 'via') {
                    console.warn('[Services/Ip@gwListProc]', 'got unexpected line:', line)
                } else {
                    const gateway = parts[2]
                    if (
                        root.gatewaysList.length < gwListProc.gatewaysList.length + 1 ||
                        root.gatewaysList[gwListProc.gatewaysList.length] !== gateway
                    ) {
                        gwListProc.updateRequired = true
                    }
                    gwListProc.gatewaysList.push(gateway)
                }
            }
        }
        // qmllint disable signal-handler-parameters
        onExited: (exitCode, _) => {
        // qmllint enable signal-handler-parameters
            if (exitCode !== 0) {
                console.warn('[Services/Ip@gwListProc]', 'exited with code:', exitCode)
            } else if (updateRequired || root.gatewaysList.length !== gatewaysList.length) {
                root.updateListGateway(gatewaysList)
                root.gatewaysList = gatewaysList
            }
            gatewaysList = []
            updateRequired = false
            gwListRestartTimer.start()
        }
    }

    Timer {
        id: gwListRestartTimer
        interval: root.gwListRefreshInterval
        running: false
        repeat: false
        onTriggered: gwListProc.running = true
    }

}
