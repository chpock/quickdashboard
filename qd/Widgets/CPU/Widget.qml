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

import QtQuick
import qs.qd.Elements as E
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    readonly property var providerCPU: Provider.CPU.instance
    readonly property var providerProcess: Provider.Process.instance

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    Connections {
        target: root.providerCPU
        function onUpdateUsage(data) {
            cpu_usage.pushValue(data.usage)
        }
        function onUpdateCoresUsage(data) {
            cores_usage.pushValues(data)
        }
    }

    Connections {
        target: root.providerProcess
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

            anchors.left: parent.left
        }

        E.TextTemperature {
            id: temperature
            theme: root._theme
            config: meter.config.temperature

            value: root.providerCPU.temperature
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.TextPercent {
            id: percent
            theme: root._theme
            config: meter.config.percent

            value: root.providerCPU.usage
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.Bar {
            id: bar
            theme: root._theme
            config: meter.config.bar

            value: root.providerCPU.usage
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
