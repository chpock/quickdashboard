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

import Quickshell
import QtQuick
import qs.qd.Services as Service

Scope {
    id: root

    readonly property alias processListModel: processListModelObj

    property real ramTotal: 0
    property real ramAvailable: 0

    property real swapTotal: 0
    property real swapFree: 0
    property bool swapIsInstalled: false

    property bool hasService: true

    Component.onCompleted: {
        if (hasService) {
            Service.Dgop.subscribe('infoMemory')
            Service.Dgop.subscribe('processesByRAM')
        }
    }

    Component.onDestruction: {
        if (hasService) {
            Service.Dgop.unsubscribe('infoMemory')
            Service.Dgop.unsubscribe('processesByRAM')
        }
    }

    Connections {
        target: Service.Dgop
        enabled: root.hasService
        function onUpdateInfoMemory(data) {
            root.ramTotal = data.total * 1024
            root.ramAvailable = data.available * 1024

            root.swapTotal = data.swaptotal * 1024
            root.swapIsInstalled = data.swaptotal !== 0
            if (root.swapIsInstalled) {
                root.swapFree = data.swapfree * 1024
            } else {
                root.swapFree = 0
                root.swapFreePercent = 0
            }
        }
        function onUpdateProcessesByRAM(data) {
            processListModelObj.updateData(data)
        }
    }

    ListModel {
        id: processListModelObj

        function updateData(data) {
            for (let i = 0; i < count; ++i) {
                const row = get(i)
                if (i < data.length) {
                    const rowValues = data[i]
                    row.command = rowValues.command
                    row.args = rowValues.args
                    row.value = rowValues.value
                } else {
                    row.command = ""
                    row.args = ""
                    row.value = 0
                }
            }
        }

        Component.onCompleted: {
            let maxProcesses = 10
            const sampleData = {
                'command': '',
                'args': '',
                'value': 0,
            }
            while (maxProcesses-- > 0) {
                append(sampleData)
            }
        }
    }

}
