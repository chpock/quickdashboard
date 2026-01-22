pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property Size _defaults

    property var height: _defaults?.height
    property var width:  _defaults?.width
}
