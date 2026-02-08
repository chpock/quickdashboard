/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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

    readonly property var _names: [
        'cyan_bright', 'cyan',
        'green_bright', 'green',
        'blue_bright', 'blue',
        'megenta_bright', 'megenta',
        'yellow_bright', 'yellow',
        'orange_bright', 'orange',
        'red_bright', 'red',
        'white_bright', 'white',
        'gray_bright', 'gray',
    ]

    function getByIndex(value) {
        const idx = (value >= _names.length || value < 0) ? 0 : value
        const name = _names[idx]
        return root[name]
    }
}
