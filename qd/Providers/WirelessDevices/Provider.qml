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
import '../../utils.js' as Utils

Scope {
    id: root

    readonly property alias ifaceModel: ifaceModelObj
    property var ifaceModelList: []

    property bool hasService: true

    function syncIfaceList(data) {
        root.ifaceModelList = []
        for (let i = 0; i < data.length; ++i) {
            const ifaceName = data[i]
            const modelData = {
                iface: ifaceName,
                ssid: 'Waiting for data...',
                signal: 0,
                isConnected: false,
                updateEpoch: -1,
            }
            root.ifaceModelList.push(ifaceName)
            if (i < ifaceModelObj.count) {
                ifaceModelObj.set(i, modelData)
            } else {
                ifaceModelObj.append(modelData)
            }
        }
        if (data.length < ifaceModelObj.count) {
            ifaceModelObj.remove(data.length, ifaceModelObj.count - data.length)
        }
    }

    function syncIfaceInfo(data) {
        for (const ifaceName in data) {
            const ifaceData = data[ifaceName]
            const idx = root.ifaceModelList.indexOf(ifaceName)
            if (idx === -1 || ifaceModelObj.get(idx).updateEpoch === ifaceData.updateEpoch) {
                continue
            }
            ifaceModelObj.set(idx, {
                ssid: ifaceData.ssid,
                isConnected: ifaceData.isConnected,
                signal: Utils.rssiToPercent(ifaceData.rssi),
                updateEpoch: ifaceData.updateEpoch,
            })
        }
    }

    Connections {
        target: Service.WirelessDevices
        enabled: root.hasService
        function onIfacesInfoChanged() {
            root.syncIfaceInfo(Service.WirelessDevices.ifacesInfo)
        }
        function onIfacesListChanged() {
            root.syncIfaceList(Service.WirelessDevices.ifacesList)
        }
    }

    Component.onCompleted: {
        if (root.hasService && Service.WirelessDevices.running) {
            root.syncIfaceList(Service.WirelessDevices.ifacesList)
            root.syncIfaceInfo(Service.WirelessDevices.ifacesInfo)
        }
    }

    ListModel {
        id: ifaceModelObj
        Component.onCompleted: {
            if (root.hasService && !root.ifaceModelList.length) {
                let stateCount = QD.Settings.stateGet('Provider.WirelessDevices.ListModel.count', 0)
                const sampleData = {
                    iface: '',
                    ssid: '',
                    signal: 0,
                    isConnected: false,
                    updateEpoch: -1,
                }
                const initialCount = ifaceModelObj.count
                while (stateCount-- > initialCount) {
                    append(sampleData)
                }
            }
        }
        onCountChanged: {
            if (root.hasService) {
                QD.Settings.stateSet('Provider.WirelessDevices.ListModel.count', count)
            }
        }
    }

}
