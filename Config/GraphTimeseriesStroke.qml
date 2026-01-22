pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property GraphTimeseriesStroke _defaults

    property var color: _defaults?.color
    property var width: _defaults?.width
}
