pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Config as C
import '../utils.js' as Utils

Item {
    id: root

    required property C.TextPercent config
    required property C.Theme theme

    property real value
    property real valueCurrent: NaN
    property real valueMax: NaN

    readonly property real calcValue:
        isNaN(valueMax)
            ? value
            : valueMax === 0
                ? 0
                : 100 * valueCurrent / valueMax

    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    E.Text {
        id: text
        theme: root.theme
        config: C.Text {
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
                _defaults: root.config.alignment
            }
            hover {
                _defaults: root.config.hover
            }
            word_spacing_font_family: root.config.word_spacing_font_family
            background: root.config.background
            overflow:   'none'
            heightMode: root.config.heightMode
            text:       root.config.text
            color:
                root.config.thresholds.enabled
                    ? root.config.thresholds.getColor(root.calcValue, root.theme)
                    : root.config.color
        }

        text: Utils.roundPercent(root.calcValue) + '%'
        anchors.fill: parent
    }
}
