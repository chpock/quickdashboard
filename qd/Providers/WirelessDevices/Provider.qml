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

    Connections {
        target: Service.WirelessDevices
        function onUpdateInfoIface(name, data) {
            const idx = root.ifaceModelList.indexOf(name)
            // If we don't have this interface in ifaceModelObj
            if (idx === -1) return
            ifaceModelObj.set(idx, {
                ssid: data.ssid,
                isConnected: data.isConnected,
                signal: Utils.rssiToPercent(data.rssi),
            })
        }
        function onUpdateListIface(data) {
            root.ifaceModelList = []
            for (let i = 0; i < data.length; ++i) {
                const iface = data[i]
                const modelData = {
                    "iface": iface,
                    "ssid": "Waiting for data...",
                    "signal": 0,
                    "isConnected": false,
                }
                root.ifaceModelList.push(iface)
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
    }

    ListModel {
        id: ifaceModelObj
        Component.onCompleted: {
            let stateCount = QD.Settings.stateGet('Provider.WirelessDevices.ListModel.count', 0)
            const sampleData = {
                'iface': '',
                'ssid': '',
                'signal': 0,
                'isConnected': false,
            }
            while (stateCount-- > 0) {
                append(sampleData)
            }
        }
        onCountChanged: {
            QD.Settings.stateSet('Provider.WirelessDevices.ListModel.count', count)
        }
    }

}
