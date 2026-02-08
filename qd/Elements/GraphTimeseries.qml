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
import '../utils.js' as Utils

Item {
    id: root

    required property C.GraphTimeseries config
    required property C.Theme theme

    // property real maxValue: 100.0
    // property real minValue: 0.0
    // property bool maxValueAuto: false
    //
    readonly property var calculateMax: Utils.calculateMax(() => config.points)

    implicitHeight: config.height + config.padding.top + config.padding.bottom

    // In my Qt version, AreaSeries doesn't fill correctly areas when the first
    // value has non-zero value. To avoid this problem, we will leave the leftmost
    // point out of the graph and set its value to 0.
    function pushValue(value) {
        graph.counter += 1
        const minX = graph.counter - config.points - 2
        points.append(graph.counter, value)
        // Remove unused points from graph. We want only config.points (visible area)
        // points + 1 invisible point with 0 value.
        if (points.count > config.points + 1) {
            points.removeMultiple(0, points.count - config.points - 1)
            // Set the leftmost value to 0
            points.replace(0, minX, 0)
        }
        if (config.axisY.extend) axisY.maxValueCalc = calculateMax.push(value)
        // Visible area should be minX+1 as we keep 1 invisible point with 0 value
        axisX.min = minX + 1
        axisX.max = graph.counter
    }

    Component.onCompleted: {
        pushValue(0)
    }

    Rectangle {
        id: border

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.right: parent.right
        anchors.rightMargin: root.config.padding.right
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        implicitHeight: root.config.height

        border {
            color: root.theme.getColor(root.config.border.color)
            width: root.config.border.width
        }
        color: 'transparent'

        GraphsView {
            id: graph
            anchors.fill: parent

            property int counter: -1

            marginBottom: root.config.border.width
            marginTop: root.config.border.width
            marginLeft: root.config.border.width
            marginRight: root.config.border.width

            theme: GraphsTheme {
                backgroundVisible: false
                plotAreaBackgroundColor: "transparent"
                gridVisible: false
                borderWidth: 0
            }

            axisX: ValueAxis {
                id: axisX
                visible: false
                lineVisible: false
                gridVisible: true
                subGridVisible: false
            }

            axisY: ValueAxis {
                id: axisY

                property real maxValueCalc: 0

                visible: false
                lineVisible: false
                gridVisible: true
                subGridVisible: false
                max:
                    root.config.axisY.extend && maxValueCalc > root.config.axisY.max
                        ? maxValueCalc
                        : root.config.axisY.max
                min: root.config.axisY.min
                Behavior on max {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            AreaSeries {
                id: area
                color: root.theme.getColor(root.config.fill)
                borderColor: root.theme.getColor(root.config.stroke.color)
                borderWidth: root.config.stroke.width
                upperSeries: LineSeries {
                    id: points
                }
            }
        }
    }
}
