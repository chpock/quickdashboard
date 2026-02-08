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

BaseStyled {
    id: root

    property Icon _defaults

    readonly property TextFont font: TextFont {
        _defaults: root._defaults?.font ?? null
    }
    readonly property TextPadding padding: TextPadding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property IconHover hover: IconHover {
        _defaults: root._defaults?.hover ?? null
    }
    readonly property IconActive active: IconActive {
        _defaults: root._defaults?.active ?? null
    }
    property var word_spacing_font_family: _defaults?.word_spacing_font_family
    property var color:       _defaults?.color
    property var background:  _defaults?.background
    property var filled:      _defaults?.filled
    property var grade:       _defaults?.grade
    property var weight:      _defaults?.weight
    property var opticalSize: _defaults?.opticalSize
    property var icon:        _defaults?.icon

    styles: _defaults?.styles

    function getStyleComponent() {
        return Qt.createComponent("Icon.qml")
    }

}
