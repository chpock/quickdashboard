pragma ComponentBehavior: Bound

import QtQuick

Base {
    property Padding _defaults

    property var top:    _defaults?.top
    property var bottom: _defaults?.bottom
    property var left:   _defaults?.left
    property var right:  _defaults?.right

    readonly property real _horizontal: left + right
    readonly property real _vertical: top + bottom
}
