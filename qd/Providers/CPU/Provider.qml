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

    signal updateUsage(var info)
    signal updateCoresUsage(var info)

    Component.onCompleted: {
        Service.Dgop.subscribe('infoCPU')
    }

    Component.onDestruction: {
        Service.Dgop.unsubscribe('infoCPU')
    }

    Connections {
        target: Service.Dgop
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

            const infoCPUCores = {
                coreUsage: data.coreUsage
            }

            root.updateCoresUsage(infoCPUCores)
        }
    }

}
