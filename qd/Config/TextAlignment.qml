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
    property TextAlignment _defaults

    property var horizontal: _defaults?.horizontal
    property var vertical:   _defaults?.vertical

    readonly property var _horizontal:
        horizontal === 'left'    ? Text.AlignLeft    :
        horizontal === 'center'  ? Text.AlignHCenter :
        horizontal === 'right'   ? Text.AlignRight   :
        horizontal === 'justify' ? Text.AlignJustify :
        horizontal

    readonly property var _vertical:
        vertical === 'top'    ? Text.AlignTop     :
        vertical === 'center' ? Text.AlignVCenter :
        vertical === 'bottom' ? Text.AlignBottom  :
        vertical
}
