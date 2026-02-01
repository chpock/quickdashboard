pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Config as C

Item {
    id: root

    required property C.TextTitle config
    required property C.Theme theme

    property alias text: title.text
    property var style
    readonly property C.TextTitle _config: (config._styles_loaded && style && config.getStyle(style)) || config

    implicitHeight: container.implicitHeight
    implicitWidth:
        title.implicitWidth +
        (root._config.separator.enabled ? separator.implicitWidth : 0)

    Rectangle {
        anchors.fill: parent
        color: root._config.background
    }

    Row {
        id: container
        spacing: 0

        // qmllint disable Quick.anchor-combinations
        anchors.left:
            root._config.alignment._horizontal === Text.AlignLeft
                ? parent.left
                : undefined
        anchors.right:
            root._config.alignment._horizontal === Text.AlignRight
                ? parent.right
                : undefined
        anchors.horizontalCenter:
            root._config.alignment._horizontal === Text.AlignHCenter
                ? parent.horizontalCenter
                : undefined
        // qmllint enable Quick.anchor-combinations

        readonly property C.Text text_config: C.Text {
            font {
                _defaults: root._config.font
            }
            padding {
                _defaults: root._config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                horizontal: 'left'
                vertical:   root._config.alignment.vertical
            }
            hover {
                _defaults: root._config.hover
            }
            word_spacing_font_family: root._config.word_spacing_font_family
            color:      root._config.color
            background: 'transparent'
            overflow:   'none'
            heightMode: root._config.heightMode
            text:       root._config.text
        }

        E.Text {
            id: title
            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                padding {
                    right:
                        root._config.separator.enabled
                            ? 0
                            : root._config.padding.right
                }
            }
        }

        E.Text {
            id: separator
            theme: root.theme
            config: C.Text {
                _defaults: container.text_config
                color: root._config.separator.color
            }

            text: title.text !== '' ? root._config.separator.text : ''
            visible: root._config.separator.enabled
        }

    }

}
