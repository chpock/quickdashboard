pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property GraphTimeseries _defaults

    readonly property GraphTimeseriesStroke stroke: GraphTimeseriesStroke {
        _defaults: root._defaults?.stroke ?? null
    }
    readonly property GraphTimeseriesAxisY axisY: GraphTimeseriesAxisY {
        _defaults: root._defaults?.axisY ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property Border border: Border {
        _defaults: root._defaults?.border ?? null
    }
    property var fill:   _defaults?.fill
    property var height: _defaults?.height
    property var points: _defaults?.points
}
