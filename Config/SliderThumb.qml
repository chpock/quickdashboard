pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property SliderThumb _defaults

    property var color:  _defaults?.color
    property var height: _defaults?.height
    property var width:  _defaults?.width
    property var gap:    _defaults?.gap
}
