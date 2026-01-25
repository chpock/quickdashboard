pragma ComponentBehavior: Bound

import QtQuick

Base {
    property GraphTimeseriesStroke _defaults

    property var color: _defaults?.color
    property var width: _defaults?.width
}
