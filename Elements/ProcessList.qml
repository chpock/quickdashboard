pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C
import qs.Elements as E
import qs

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
        list.recomputeRightWidth()
    }

    Component {
        id: defaultValueRenderer

        E.Text {
            property var modelValue

            theme: root.theme
            config: root.config.value

            text: modelValue
            // text: 'foo1'
            // preset: Theme.processList.preset
            // color: Theme.processList.colors.value
            // horizontalAlignment: Text.AlignRight
            // width: list.colValueWidth
            // visible: root.valueRenderer === null
        }
    }

    ListModel {
        id: rows
        Component.onCompleted: {
            let stateCount = SettingsData.stateGet('Element.ProcessList.ListModel.count', 3)
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
            SettingsData.stateSet('Element.ProcessList.ListModel.count', count)
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
