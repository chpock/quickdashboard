pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    readonly property var providerMemory: Provider.Memory.instance
    readonly property var providerProcess: Provider.Process.instance

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    Connections {
        target: root.providerProcess
        function onUpdateProcessesByRAM(data) {
            processList.pushValues(data)
        }
    }

    readonly property int titleWidth: Math.max(meterRAM.titleWidth, meterSwap.titleWidth)

    component Meter: Item {
        id: meter

        readonly property alias titleWidth: titleObj.implicitWidth
        readonly property var config: root._fragments.meter

        required property string style
        property alias free: freeObj.value
        property alias total: totalObj.value

        implicitHeight:
            Math.max(
                titleObj.implicitHeight,
                freeObj.implicitHeight,
                totalObj.implicitHeight,
                percentObj.implicitHeight
            ) +
            barObj.implicitHeight

        E.TextTitle {
            id: titleObj
            theme: root._theme
            config: meter.config.title

            style: meter.style
            anchors.left: parent.left
            width: root.titleWidth
        }

        // qmllint disable required
        E.TextBytes {
            id: freeObj
            theme: root._theme
            config: meter.config.free

            anchors.left: titleObj.right
            anchors.bottom: titleObj.bottom
        }
        // qmllint enable required

        // qmllint disable required
        E.TextBytes {
            id: totalObj
            theme: root._theme
            config: meter.config.total

            anchors.left: freeObj.right
            anchors.bottom: titleObj.bottom
        }
        // qmllint enable required

        E.TextPercent {
            id: percentObj
            theme: root._theme
            config: meter.config.percent

            valueCurrent: meter.total - meter.free
            valueMax: meter.total
            anchors.right: parent.right
        }

        E.Bar {
            id: barObj
            theme: root._theme
            config: meter.config.bar

            value: percentObj.calcValue
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Meter {
        id: meterRAM

        anchors.left: parent.left
        anchors.right: parent.right

        style: 'ram'
        free:  root.providerMemory.ramAvailable
        total: root.providerMemory.ramTotal
    }

    Meter {
        id: meterSwap

        anchors.left: parent.left
        anchors.right: parent.right

        style: 'swap'
        free:  root.providerMemory.swapFree
        total: root.providerMemory.swapTotal
    }

    E.ProcessList {
        id: processList
        theme: root._theme
        config: root._fragments.processes.list

        anchors.left: parent.left
        anchors.right: parent.right

        E.TextBytes {
            theme: root._theme
            config: root._fragments.processes.value

            property var modelValue
            // qmllint disable unqualified
            value: modelValue
            // qmllint enable unqualified
        }
    }

}
