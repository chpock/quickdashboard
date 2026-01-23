pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
import '../utils.js' as Utils

Item {
    id: root

    required property C.TextTemperature config
    required property C.Theme theme

    property real value

    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    E.Text {
        id: text

        theme: root.theme
        config: C.Text {
            _defaults: root.config.text
            color:
                root.config.thresholds.enabled
                    ? root.config.thresholds.getColor(root.value, root.theme)
                    : root.config.text.color
        }

        text: Utils.roundPercent(root.value) + "\u2103"
        anchors.fill: parent
    }
}
