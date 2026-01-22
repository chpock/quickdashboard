pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C
import qs.Elements as E

Item {
    id: root

    required property C.Icon config
    required property C.Theme theme

    required property string icon
    property var style
    readonly property C.Icon _config: {
        if (config._styles_loaded && style) {
            for (var i = 0; i < config.styles.length; ++i) {
                if (config.styles[i].style === style) {
                    return config.styles[i]
                }
            }
        }
        return config
    }
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
                size:      root._config.font.size
                weight:    root._config.font.weight
                family:    root._config.font.family
                strikeout: root._config.font.strikeout
            }
            overflow:   C.Text.OverflowNone
            heightMode: C.Text.HeightNormal
            padding {
                left:   root._config.padding.left
                right:  root._config.padding.right
                top:    root._config.padding.top
                bottom: root._config.padding.bottom
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
            text: 'question_mark'

            C.Text {
                style: 'hover'
                color: root._config.hover.color
            }
            C.Text {
                style: 'active'
                color: root._config.active.color
            }
        }

        text: root.icon
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
