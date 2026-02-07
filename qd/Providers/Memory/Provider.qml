pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.qd.Services as Service

Scope {
    id: root

    property real ramTotal: 0
    property real ramAvailable: 0

    property real swapTotal: 0
    property real swapFree: 0
    property bool swapIsInstalled: false

    Component.onCompleted: {
        Service.Dgop.subscribe('infoMemory')
    }

    Component.onDestruction: {
        Service.Dgop.unsubscribe('infoMemory')
    }

    Connections {
        target: Service.Dgop
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
    }

}
