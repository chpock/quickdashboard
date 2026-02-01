pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Config as C

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
            id: title
            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                padding {
                    right:
                        root.config.separator.enabled
                            ? 0
                            : root.config.padding.right
                }
            }
        }

        E.Text {
            id: separator
            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                color: root.config.separator.color
            }

            text: title.text !== '' ? root.config.separator.text : ''
            visible: root.config.separator.enabled
        }

    }

}
