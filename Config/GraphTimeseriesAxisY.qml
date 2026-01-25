pragma ComponentBehavior: Bound

import QtQuick

Base {
    property GraphTimeseriesAxisY _defaults

    property var max:    _defaults?.max
    property var min:    _defaults?.min
    property var extend: _defaults?.extend
}
