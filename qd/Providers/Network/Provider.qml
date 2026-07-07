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

    readonly property var rate: QtObject {
        property real download: 0
        property real upload: 0
    }

    readonly property var latency: QtObject {
        property string name: ''
        property string host: ''
        property real time: Infinity
    }

    readonly property var gatewayDefault: QtObject {
        property string host: ''
        property real latency: Infinity
        property var updateEpoch: -1
    }

    readonly property alias latencyHostsModel: latencyHostsModelObj

    property real dnsCheckTime: Service.Getent.dnsCheckTime

    property bool hasService: true

    signal updateNetworkRate(var info)

    Component.onCompleted: {
        if (root.hasService) {
            Service.Dgop.subscribe('infoNetwork')
            latencyHostsModelObj.updateElements(Service.Ping.pingHostsList)
            root.syncPingInfo(Service.Ping.pingInfo)
            root.syncInfoNetwork(Service.Dgop.infoNetwork)
        }
    }

    Component.onDestruction: {
        if (root.hasService) {
            Service.Dgop.unsubscribe('infoNetwork')
        }
    }

    Connections {
        target: Service.Dgop
        enabled: root.hasService
        function onInfoNetworkChanged() {
            root.syncInfoNetwork(Service.Dgop.infoNetwork)
        }
    }

    function syncInfoNetwork(data) {
        if (!data) {
            return
        }
        root.rate.download = data.rxrate
        root.rate.upload = data.txrate
        root.updateNetworkRate(data)
    }

    Connections {
        target: Service.Ping
        enabled: root.hasService
        function onGatewayHostsListChanged() {
            if (!Service.Ping.gatewayHostsList.length) {
                root.gatewayDefault.host = ''
                root.gatewayDefault.latency = Infinity
                root.gatewayDefault.updateEpoch = -1
            }
        }
        function onPingHostsListChanged() {
            latencyHostsModelObj.updateElements(Service.Ping.pingHostsList)
        }
        function onPingInfoUpdated() {
            root.syncPingInfo(Service.Ping.pingInfo)
        }
    }

    function syncPingInfo(data) {
        let needRefresh = false
        for (const pingInfo of data) {
            if (pingInfo.isGateway) {
                if (pingInfo.isDefault && pingInfo.updateEpoch !== root.gatewayDefault.updateEpoch) {
                    root.gatewayDefault.host = pingInfo.host
                    root.gatewayDefault.latency = pingInfo.value
                    root.gatewayDefault.updateEpoch = pingInfo.updateEpoch
                }
                continue
            }
            const idx = latencyHostsModelObj.knownHosts.indexOf(pingInfo.host)
            if (idx === -1) {
                continue
            }
            if (latencyHostsModelObj.latencyValues[idx].updateEpoch === pingInfo.updateEpoch) {
                continue
            }
            latencyHostsModelObj.latencyValues[idx].value = pingInfo.value
            latencyHostsModelObj.latencyValues[idx].updateEpoch = pingInfo.updateEpoch
            latencyHostsModelObj.setProperty(idx, 'time', pingInfo.value)
            needRefresh = true
        }
        if (needRefresh) {
            root.refreshLatency()
        }
    }

    function refreshLatency() {
        let bestPingName = ''
        let bestPingHost = ''
        let bestPingTime = Infinity
        for (let i = 0; i < latencyHostsModelObj.knownHosts.length; ++i) {
            const value = latencyHostsModelObj.latencyValues[i].value
            if (Number.isFinite(value) && (!Number.isFinite(bestPingTime) || value < bestPingTime)) {
                bestPingTime = value
                bestPingHost = latencyHostsModelObj.knownHosts[i]
                bestPingName = latencyHostsModelObj.get(i).name
            }
        }
        latency.name = bestPingName
        latency.host = bestPingHost
        latency.time = bestPingTime
    }

    ListModel {
        id: latencyHostsModelObj

        property var knownHosts: []
        property var latencyValues: []

        function updateElements(data) {
            let updated = false
            const updatedKnownHosts = []
            for (const idx in data) {
                const host = data[idx].host
                const name = data[idx].name
                updatedKnownHosts.push(host)
                const entry = {
                    value: Infinity,
                    updateEpoch: -1,
                }
                if (idx < latencyHostsModelObj.count) {
                    if (knownHosts[idx] === host) continue
                    set(idx, { name: name, host: host, time: Infinity })
                    latencyValues[idx] = entry
                } else {
                    append({ name: name, host: host, time: Infinity })
                    latencyValues.push(entry)
                }
                updated = true
            }
            if (data.length < latencyHostsModelObj.count) {
                remove(data.length, latencyHostsModelObj.count - data.length)
                latencyValues.splice(data.length)
                updated = true
            }
            // Recreate knownHosts array to trigger possible updates (if anything
            // subscribed to its changed)
            knownHosts = updatedKnownHosts
            root.refreshLatency()
        }
    }


}
