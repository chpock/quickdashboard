pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C

Item {
    id: root

    required property C.TextTitle config
    required property C.Theme theme

    property alias text: title.text

    implicitHeight: container.implicitHeight
    implicitWidth:
        title.implicitWidth +
        (root.config.separator.enabled ? separator.implicitWidth : 0)

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
            id: title

            theme: root.theme
            config: C.Text {
                _defaults: root.config.text
                padding {
                    right:
                        root.config.separator.enabled
                            ? 0
                            : root.config.text.padding.right
                }
                background: 'transparent'
            }
        }

        E.Text {
            id: separator

            theme: root.theme
            config: C.Text {
                _defaults: root.config.text
                color: root.config.separator.color
                background: 'transparent'
            }

            text: title.text !== '' ? root.config.separator.text : ''
            visible: root.config.separator.enabled
        }

    }

}
