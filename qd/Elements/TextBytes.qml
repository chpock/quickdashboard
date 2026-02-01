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
        color: root.config.background
    }

    Row {
        id: container
        spacing: 0

        // qmllint disable Quick.anchor-combinations
        anchors.left:
            root.config.alignment._horizontal === Text.AlignLeft
                ? parent.left
                : undefined
        anchors.right:
            root.config.alignment._horizontal === Text.AlignRight
                ? parent.right
                : undefined
        anchors.horizontalCenter:
            root.config.alignment._horizontal === Text.AlignHCenter
                ? parent.horizontalCenter
                : undefined
        // qmllint enable Quick.anchor-combinations

        readonly property C.Text text_config: C.Text {
            font {
                _defaults: root.config.font
            }
            padding {
                _defaults: root.config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                horizontal: 'left'
                vertical:   root.config.alignment.vertical
            }
            hover {
                _defaults: root.config.hover
            }
            word_spacing_font_family: root.config.word_spacing_font_family
            color:      root.config.color
            background: 'transparent'
            overflow:   'none'
            heightMode: root.config.heightMode
            text:       root.config.text
        }

        E.Text {
            id: valueObj
            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                padding {
                    right: '1ch'
                }
            }

            text: root.config.prefix + root.formatedValue[0]
        }

        E.Text {
            id: unitObj

            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                padding {
                    right: 0
                    left:  0
                }
            }

            text: root.formatedValue[1]
        }

        E.Text {
            id: suffix

            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                padding {
                    left:  0
                }
            }

            text: root.isRate ? 'b/s' : 'b'
        }

    }

}
