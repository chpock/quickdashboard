pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property Bar _defaults

    readonly property BarColor color: BarColor {
        _defaults: root._defaults?.color ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
    property var height: _defaults?.height
}
