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
