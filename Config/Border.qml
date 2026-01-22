pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property Border _defaults

    property var width: _defaults?.width
    property var color: _defaults?.color
}
