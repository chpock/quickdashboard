pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property SliderBar _defaults

    readonly property BarColor color: BarColor {
        _defaults: root._defaults?.color ?? null
    }
    property var height: _defaults?.height
}
