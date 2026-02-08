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
import QtGraphs
import qs.qd.Config as C

Item {
    id: root

    required property C.GraphBars config
    required property C.Theme theme

    // required property color color

    property real maxValue: 100.0

    implicitHeight: config.height + config.padding.top + config.padding.bottom

    function pushValues(values) {
        if (barSeries.count > values.length) {
            barSeries.removeMultiple(0, barSeries.count - values.length);
        } else if (barSeries.count < values.length) {
            for (let i = barSeries.count; i < values.length; ++i) {
                const set = Qt.createQmlObject('import QtGraphs; BarSet {}', barSeries)
                barSeries.append(set);
            }
        }
        for (let i = 0; i < values.length; ++i) {
            const v = Math.round(values[i]);
            const set = barSeries.at(i)
            if (set.values[0] !== v) {
                set.values = [v]
                set.color = config.thresholds.getColor(v, theme)
                // for (let j = 0; j < Theme.graph.bar.thresholds.length; ++j) {
                //     const threshold = Theme.graph.bar.thresholds[j];
                //     if (threshold.value === -1 || v <= threshold.value) {
                //         set.color = threshold.color
                //         break
                //     }
                // }
            }
        }
    }

    Rectangle {
        id: border
        anchors.fill: parent

        border {
            color: root.theme.getColor(root.config.border.color)
            width: root.config.border.width
        }
        color: "transparent"

        GraphsView {
            id: graph
            anchors.fill: parent
            anchors.margins: root.config.border.width + 2

            marginBottom: 0
            marginTop: 0
            marginLeft: 0
            marginRight: 0

            theme: GraphsTheme {
                backgroundVisible: false
                plotAreaBackgroundColor: "transparent"
                gridVisible: false
                labelsVisible: false
                borderWidth: 0
            }

            axisY: ValueAxis {
                id: axisY
                min: 0
                max: root.maxValue
                visible: false
                labelsVisible: false
                lineVisible: false
                gridVisible: false
                subGridVisible: false
                titleVisible: false
            }
            axisX: BarCategoryAxis {
                id: axisX
                visible: false
                labelsVisible: false
                lineVisible: false
                gridVisible: false
                subGridVisible: false
                titleVisible: false
            }

            BarSeries {
                id: barSeries
                barWidth: 1
                barDelegate: Rectangle {
                    property color barColor
                    color: barColor
                    // no rounding
                    radius: 0
                }
            }

        }
    }
}
