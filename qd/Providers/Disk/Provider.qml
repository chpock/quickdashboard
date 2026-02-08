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
import qs.qd as QD

Scope {
    id: root

    readonly property alias mountModel: mountModelObj
    property var mountModelList: []

    readonly property var rate: QtObject {
        property real read: 0
        property real write: 0
    }

    signal updateDiskRate(var info)

    Component.onCompleted: {
        Service.Dgop.subscribe('infoDisk')
        Service.Dgop.subscribe('infoMounts')
    }

    Component.onDestruction: {
        Service.Dgop.unsubscribe('infoDisk')
        Service.Dgop.unsubscribe('infoMounts')
    }

    Connections {
        target: Service.Dgop
        function onUpdateInfoDisk(data) {
            root.rate.read = data.readrate
            root.rate.write = data.writerate
            root.updateDiskRate(data)
        }
        function onUpdateInfoMounts(data) {
            const foundMounts = []
            for (let item of data) {
                const mount = data.mount
                const idx = root.mountModelList.indexOf(mount)
                if (idx === -1) {
                    mountModelObj.append(data)
                    root.mountModelList.push(mount)
                } else {
                    mountModelObj.set(idx, data)
                }
                foundMounts.push(mount)
            }
            if (foundMounts.length !== root.mountModelList.length) {
                for (let i = root.mountModelList.length - 1; i >= 0; --i) {
                    if (foundMounts.indexOf(root.mountModelList[i]) === -1)
                        mountModelObj.remove(i, 1)
                }
                root.mountModelList = foundMounts
            }
        }
    }

    ListModel {
        id: mountModelObj
        Component.onCompleted: {
            let stateCount = QD.Settings.stateGet('Provider.Disk.ListModel.count', 0)
            const sampleData = {
                'device': '',
                'mount': '',
                'fstype': '',
                'size': 0,
                'used': 0,
                'avail': 0,
            }
            while (stateCount-- > 0) {
                append(sampleData)
                root.mountModelList.push('')
            }
        }
        onCountChanged: {
            QD.Settings.stateSet('Provider.Disk.ListModel.count', count)
        }
    }

}
