pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    Connections {
        target: Provider.CPU
        function onUpdateCPU(data) {
            cpu_usage.pushValue(data.usage)
        }
        function onUpdateCPUCores(data) {
            cores_usage.pushValues(data.coreUsage)
        }
    }

    Connections {
        target: Provider.Process
        function onUpdateProcessesByCPU(data) {
            processList.pushValues(data)
        }
    }

    component Meter: Item {
        id: meter

        readonly property var config: root._fragments.meter

        implicitHeight:
            Math.max(
                title.implicitHeight,
                temperature.implicitHeight,
                percent.implicitHeight,
            ) +
            bar.implicitHeight

        E.TextTitle {
            id: title
            theme: root._theme
            config: meter.config.title

            text: 'CPU'
            anchors.left: parent.left
        }

        E.TextTemperature {
            id: temperature
            theme: root._theme
            config: meter.config.temperature

            value: Provider.CPU.cpu.temperature
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.TextPercent {
            id: percent
            theme: root._theme
            config: meter.config.percent

            value: Provider.CPU.cpu.usage
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.Bar {
            id: bar
            theme: root._theme
            config: meter.config.bar

            value: Provider.CPU.cpu.usage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Meter {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: root._widget.spacing.horizontal

        E.GraphTimeseries {
            id: cpu_usage
            theme: root._theme
            config: root._fragments.graph.cpu_usage

            width: (parent.width - parent.spacing) / 2
        }

        E.GraphBars {
            id: cores_usage
            theme: root._theme
            config: root._fragments.graph.cores_usage

            width: (parent.width - parent.spacing) / 2
        }
    }

    E.ProcessList {
        id: processList

        theme: root._theme
        config: root._fragments.processes.list

        anchors.left: parent.left
        anchors.right: parent.right

        E.TextPercent {
            theme: root._theme
            config: root._fragments.processes.value

            property var modelValue
            // qmllint disable unqualified
            value: modelValue
            // qmllint enable unqualified
        }
    }

}
