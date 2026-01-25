pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property ThemePalette _defaults

    property var cyan_bright:    _defaults?.cyan_bright
    property var cyan:           _defaults?.cyan
    property var green_bright:   _defaults?.green_bright
    property var green:          _defaults?.green
    property var blue_bright:    _defaults?.blue_bright
    property var blue:           _defaults?.blue
    property var megenta_bright: _defaults?.megenta_bright
    property var megenta:        _defaults?.megenta
    property var yellow_bright:  _defaults?.yellow_bright
    property var yellow:         _defaults?.yellow
    property var orange_bright:  _defaults?.orange_bright
    property var orange:         _defaults?.orange
    property var red_bright:     _defaults?.red_bright
    property var red:            _defaults?.red
    property var white_bright:   _defaults?.white_bright
    property var white:          _defaults?.white
    property var gray_bright:    _defaults?.gray_bright
    property var gray:           _defaults?.gray

    property var names:          _defaults?.names

    function getByIndex(value) {
        const idx = (value >= names.length || value < 0) ? 0 : value
        const name = names[idx]
        return root[name]
    }
}
