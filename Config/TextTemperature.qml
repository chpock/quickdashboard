pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C

QtObject {
    id: root

    property TextTemperature _defaults

    readonly property C.Text text: C.Text {
        _defaults: root._defaults?.text ?? null
    }
    readonly property Thresholds thresholds: Thresholds {
        _defaults: root._defaults?.thresholds ?? null
    }
}
