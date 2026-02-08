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

property string model: "Unknown"
    property int cores: 0
    property real frequency: 0
    property real usage: 0
    property real temperature: 0

    property bool hasService: true

    signal updateUsage(var info)
    signal updateCoresUsage(var info)

Component.onCompleted: {
        if (hasService) {
            Service.Dgop.subscribe('infoCPU')
        }
    }

    Component.onDestruction: {
        if (hasService) {
            Service.Dgop.unsubscribe('infoCPU')
        }
    }

    Connections {
        target: Service.Dgop
        enabled: root.hasService
        function onUpdateInfoCPU(data) {
            root.model = data.model
            root.cores = data.count
            root.frequency = data.frequency
            root.usage = data.usage
            root.temperature = data.temperature

            const infoCPU = {
                frequency: data.frequency,
                temperature: data.temperature,
                usage: data.usage,
            }

            root.updateUsage(infoCPU)
            root.updateCoresUsage(data.coreUsage)
        }
    }

}
