pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
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
            _defaults: root.config.text
            color:
                root.config.thresholds.enabled
                    ? root.config.thresholds.getColor(root.calcValue, root.theme)
                    : root.config.text.color
        }

        text: Utils.roundPercent(root.calcValue) + '%'
        anchors.fill: parent
    }
}
