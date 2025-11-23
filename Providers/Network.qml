pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import qs.Services as Service

Singleton {
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

    readonly property alias latencyHostsModel: latencyHostsModelObj

    readonly property real dnsCheckTime: Service.Getent.dnsCheckTime

    signal updateNetworkRate(var info)

    Component.onCompleted: {
        Service.Dgop.subscribe('infoNetwork')
    }

    Component.onDestruction: {
        Service.Dgop.unsubscribe('infoNetwork')
    }

    Connections {
        target: Service.Dgop
        function onUpdateInfoNetwork(data) {
            root.rate.download = data.rxrate
            root.rate.upload = data.txrate
            root.updateNetworkRate(data)
        }
    }

    Connections {
        target: Service.Ping
        function onUpdateInfoPing(data, value) {
            const idx = latencyHostsModelObj.knownHosts.indexOf(data.host)
            if (idx === -1) return
            latencyHostsModelObj.latencyValues[idx] = value
            latencyHostsModelObj.setProperty(idx, 'time', value)
            root.refreshLatency()
        }
        function onUpdateListHost(data) {
            latencyHostsModelObj.updateElements(data)
        }
    }

    function refreshLatency() {
        let bestPingName = ''
        let bestPingHost = ''
        let bestPingTime = Infinity
        for (let i = 0; i < latencyHostsModelObj.knownHosts.length; ++i) {
            const value = latencyHostsModelObj.latencyValues[i]
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
                if (idx < latencyHostsModelObj.count) {
                    if (knownHosts[idx] === host) continue
                    set(idx, { name: name, host: host, time: Infinity })
                    latencyValues[idx] = Infinity
                } else {
                    append({ name: name, host: host, time: Infinity })
                    latencyValues.push(Infinity)
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

        Component.onCompleted: {
            updateElements(Service.Ping.hostsList)
        }
    }


}
