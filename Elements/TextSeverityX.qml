pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C

Item {
    id: root

    required property C.TextSeverity config
    required property C.Theme theme

    property real value: NaN
    property alias text: text.text

    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    E.TextX {
        id: text

        theme: root.theme
        config: C.Text {
            _defaults: root.config.text
            color:
                root.config.thresholds.enabled
                    ? root.config.thresholds.getColor(root.value, root.theme)
                    : root.config.text.color
        }
    }
}
