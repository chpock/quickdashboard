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

Item {
    id: root

    required property C.ProcessList config
    required property C.Theme theme
    required property var model
    property int maxLines: -1

    default property Component valueRenderer: defaultValueRenderer

    property real valueColumnWidth: 0

    implicitHeight: column.implicitHeight + config.padding.top + config.padding.bottom

    function recomputeValueColumnWidth() {
        let maxw = 0
        const linesCount =
            maxLines < 0
                ? rows.count
                : Math.min(maxLines, rows.count)
        for (let i = 0; i < linesCount; ++i) {
            const row = rows.itemAt(i)
            if (row) {
                maxw = Math.max(maxw, row.valueImplicitWidth) // qmllint disable missing-property
            }
        }

        valueColumnWidth = maxw
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

    Column {
        id: column

        anchors.fill: parent
        anchors.leftMargin: root.config.padding.left
        anchors.rightMargin: root.config.padding.right
        anchors.topMargin: root.config.padding.top
        anchors.bottomMargin: root.config.padding.bottom

        spacing: root.config.spacing.horizontal

        Repeater {
            id: rows

            model: root.model

            onCountChanged: Qt.callLater(root.recomputeValueColumnWidth)

            Item {
                id: row

                required property var model
                required property int index

                visible: root.maxLines >= 0 && index >= root.maxLines ? false : true
                width: column.width
                height: Math.max(
                    command.implicitHeight,
                    args.implicitHeight,
                    valueLoader.item ? valueLoader.item.implicitHeight : 0 // qmllint disable missing-property
                )

                readonly property real valueImplicitWidth:
                    valueLoader.item ? valueLoader.item.implicitWidth : 0 // qmllint disable missing-property

                readonly property real availableForText:
                    Math.max(0, width - root.valueColumnWidth)

                readonly property real commandWidth:
                    Math.min(command.implicitWidth, availableForText)

                readonly property real argsWidth:
                    Math.max(0, availableForText - commandWidth)

                onValueImplicitWidthChanged: Qt.callLater(root.recomputeValueColumnWidth)

                Component.onCompleted: Qt.callLater(root.recomputeValueColumnWidth)
                Component.onDestruction: Qt.callLater(root.recomputeValueColumnWidth)

                Row {
                    anchors.fill: parent
                    spacing: 0

                    E.Text {
                        id: command

                        theme: root.theme
                        config: root.config.command

                        text: row.model.command

                        width: row.commandWidth
                    }

                    E.Text {
                        id: args

                        theme: root.theme
                        config: root.config.args

                        text: row.model.args

                        width: row.argsWidth
                    }

                    Loader {
                        id: valueLoader

                        readonly property var modelValue: row.model.value

                        width: root.valueColumnWidth
                        sourceComponent: root.valueRenderer

                        onStatusChanged: Qt.callLater(root.recomputeValueColumnWidth)

                        Binding {
                            target: valueLoader.item
                            property: "modelValue"
                            value: valueLoader.modelValue
                            when: valueLoader.status === Loader.Ready
                        }
                    }
                }
            }
        }
    }

}
