pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Config as C
import '../utils.js' as Utils

Item {
    id: root

    required property C.TextBytes config
    required property C.Theme theme

    required property var value
    property bool isRate: false

    readonly property var formatedValue: Utils.formatBytes(value, config.precision)

    implicitHeight: container.implicitHeight
    implicitWidth: valueObj.implicitWidth + unitObj.implicitWidth + suffix.implicitWidth

    Rectangle {
        anchors.fill: parent
        color: root.config.text.background
    }

    Row {
        id: container
        spacing: 0

        // qmllint disable Quick.anchor-combinations
        anchors.left:
            root.config.text.alignment._horizontal === Text.AlignLeft
                ? parent.left
                : undefined
        anchors.right:
            root.config.text.alignment._horizontal === Text.AlignRight
                ? parent.right
                : undefined
        anchors.horizontalCenter:
            root.config.text.alignment._horizontal === Text.AlignHCenter
                ? parent.horizontalCenter
                : undefined

        E.Text {
            id: valueObj

            theme: root.theme
            config: C.Text {
                _defaults: root.config.text
                padding {
                    right: '1ch'
                }
                background: 'transparent'
            }

            text: root.config.prefix + root.formatedValue[0]
        }

        E.Text {
            id: unitObj

            theme: root.theme
            config: C.Text {
                _defaults: root.config.text
                padding {
                    right: 0
                    left:  0
                }
                background: 'transparent'
            }

            text: root.formatedValue[1]
        }

        E.Text {
            id: suffix

            theme: root.theme
            config: C.Text {
                _defaults: root.config.text
                padding {
                    left:  0
                }
                background: 'transparent'
            }

            text: root.isRate ? 'b/s' : 'b'
        }

    }

}
