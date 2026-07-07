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

    property bool hasService: true

    signal updateDiskRate(var info)

    Component.onCompleted: {
        if (root.hasService) {
            const persistedStateCount = mountModelObj.getStateCount()

            if (!root.mountModelList.length) {
                let stateCount = persistedStateCount
                const sampleData = {
                    device: '',
                    mount:  '',
                    fstype: '',
                    size:  0,
                    used:  0,
                    avail: 0,
                }
                const initialCount = mountModelObj.count
                while (stateCount-- > initialCount) {
                    mountModelObj.append(sampleData)
                    root.mountModelList.push('')
                }
            }

            Service.Dgop.subscribe('infoDisk')
            Service.Dgop.subscribe('infoMounts')
            root.syncInfoDisk(Service.Dgop.infoDisk)
            root.syncInfoMounts(Service.Dgop.infoMounts)

            mountModelObj.stateCountInitialized = true
            if (mountModelObj.realCountKnown) {
                if (persistedStateCount < 0 || persistedStateCount !== mountModelObj.count) {
                    mountModelObj.setStateCount()
                }
            }
        }
    }

    Component.onDestruction: {
        if (root.hasService) {
            Service.Dgop.unsubscribe('infoDisk')
            Service.Dgop.unsubscribe('infoMounts')
        }
    }

    function syncInfoDisk(data) {
        if (!data) {
            return
        }
        root.rate.read = data.readrate
        root.rate.write = data.writerate
        root.updateDiskRate(data)
    }

    function syncInfoMounts(data) {
        if (!data) {
            return
        }
        mountModelObj.realCountKnown = true
        const foundMounts = []
        for (let item of data) {
            const mount = item.mount
            const idx = root.mountModelList.indexOf(mount)
            if (idx === -1) {
                mountModelObj.append(item)
                root.mountModelList.push(mount)
            } else {
                mountModelObj.set(idx, item)
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

    Connections {
        target: Service.Dgop
        enabled: root.hasService
        function onInfoDiskChanged() {
            root.syncInfoDisk(Service.Dgop.infoDisk)
        }
        function onInfoMountsChanged() {
            root.syncInfoMounts(Service.Dgop.infoMounts)
        }
    }

    ListModel {
        id: mountModelObj

        property bool stateCountInitialized: false
        property bool realCountKnown: false
        readonly property string stateCountKey: 'Provider.Disk.ListModel.count'

        function getStateCount() {
            let stateCount = Number(QD.Settings.stateGet(stateCountKey, -1))
            if (!Number.isFinite(stateCount) || stateCount < 0) {
                return -1
            }
            return Math.trunc(stateCount)
        }

        function setStateCount() {
            QD.Settings.stateSet(stateCountKey, count)
        }

        onCountChanged: {
            if (!root.hasService || !stateCountInitialized || !realCountKnown) {
                return
            }
            setStateCount()
        }
    }

}
