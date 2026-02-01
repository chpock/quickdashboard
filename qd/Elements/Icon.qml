pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C
import qs.qd.Elements as E

Item {
    id: root

    required property C.Icon config
    required property C.Theme theme

    property var icon
    property var style
    readonly property C.Icon _config: (config._styles_loaded && style && config.getStyle(style)) || config

    property bool isActive

    readonly property real fill: _config.filled ? 1.0 : 0.0

    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    signal clicked()

    E.Text {
        id: text

        theme: root.theme
        config: C.Text {
            font {
                _defaults: root._config.font
            }
            overflow:   C.Text.OverflowNone
            heightMode: C.Text.HeightNormal
            padding {
                _defaults: root._config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                horizontal: Text.AlignHCenter
                vertical:   Text.AlignVCenter
            }
            hover {
                enabled: root._config.hover.enabled
            }
            word_spacing_font_family: root._config.word_spacing_font_family
            color: root._config.color
            background: root._config.background
            styles: ({
                hover: {
                    color: root._config.hover.color,
                },
                active: {
                    color: root._config.active.color,
                },
            })
        }

        text: root.icon == null ? root._config.icon : root.icon
        style:
            isHovered
                ? 'hover'
                : root.isActive
                    ? 'active'
                    : undefined
        // // heightMode: E.Text.Content
        anchors.fill: parent
        antialiasing: true
        fontVariableAxes: ({
            "FILL": root.fill.toFixed(1),
            "GRAD": root._config.grade,
            "opsz": root._config.opticalSize,
            "wght": root._config.weight,
        })
    }

    TapHandler {
        onTapped: root.clicked()
    }
}
