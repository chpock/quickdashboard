pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property GraphBars _defaults

    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property Border border: Border {
        _defaults: root._defaults?.border ?? null
    }
    readonly property Thresholds thresholds: Thresholds {
        _defaults: root._defaults?.thresholds ?? null
    }
    property var height: _defaults?.height
}
