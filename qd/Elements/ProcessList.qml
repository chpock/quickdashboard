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
import qs.qd.Config as C
import qs.qd.Elements as E
import qs.qd as QD

Item {
    id: root

    required property C.ProcessList config
    required property C.Theme theme

    default property Component valueRenderer: defaultValueRenderer

    implicitHeight: list.implicitHeight + config.padding.top + config.padding.bottom

    function pushValues(values) {
        for (let i = 0; i < rows.count; ++i) {
            const row = rows.get(i)
            if (i < values.length) {
                const rowValues = values[i]
                row.command = rowValues.command
                row.args = rowValues.args
                row.value = rowValues.value
            } else {
                row.command = ""
                row.args = ""
                row.value = 0
            }
        }
        // We need to call it later as it doesn't work in demo mode when provider
        // pushes values in Component.onCompleted event. Width remains as 0 in this case.
        Qt.callLater(list.recomputeRightWidth)
    }

    Component {
        id: defaultValueRenderer

        E.Text {
            property var modelValue

            theme: root.theme
            config: root.config.value

            text: modelValue
        }
    }

    ListModel {
        id: rows
        Component.onCompleted: {
            let stateCount = QD.Settings.stateGet('Element.ProcessList.ListModel.count', 3)
            const sampleData = {
                'command': '',
                'args': '',
                'value': 0,
            }
            while (stateCount-- > 0) {
                append(sampleData)
            }
        }
        onCountChanged: {
            QD.Settings.stateSet('Element.ProcessList.ListModel.count', count)
        }
    }

    ListView {
        id: list

        anchors.fill: parent
        anchors.leftMargin: root.config.padding.left
        anchors.rightMargin: root.config.padding.right
        anchors.topMargin: root.config.padding.top
        anchors.bottomMargin: root.config.padding.bottom
        spacing: root.config.spacing.horizontal
        implicitHeight: contentHeight

        model: rows

        property real colValueWidth: 0

        function recomputeRightWidth() {
            var maxw = 0
            for (let i = 0; i < list.count; ++i) {
                const d = list.itemAtIndex(i)
                if (d) {
                    const currentWidth = d.children[0].children[2].implicitWidth
                    maxw = Math.max(maxw, currentWidth)
                }
            }
            colValueWidth = maxw
        }

        delegate: Item {
            id: item
            width: list.width
            height: Math.max(command.implicitHeight, args.implicitHeight)
            required property var model

            Row {
                id: row
                anchors.fill: parent
                spacing: 0

                E.Text {
                    id: command

                    theme: root.theme
                    config: root.config.command

                    text: item.model.command
                    width:
                        implicitWidth > (parent.width - list.colValueWidth)
                            ? parent.width - list.colValueWidth
                            : undefined
                }

                E.Text {
                    id: args

                    theme: root.theme
                    config: root.config.args

                    text: item.model.args
                    width: Math.max(0, parent.width - command.implicitWidth - list.colValueWidth)
                }

                Loader {
                    readonly property var modelValue: item.model.value
                    id: colValueLoader
                    width: list.colValueWidth
                    sourceComponent: root.valueRenderer
                    Binding {
                        target: colValueLoader.item
                        property: "modelValue"
                        value: colValueLoader.modelValue
                        when: colValueLoader.status === Loader.Ready
                    }
                }
            }
        }
    }
}
