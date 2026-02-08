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
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    enum Align {
        AlignRight = 0,
        AlignLeft = 1
    }

    default property alias content: content.data
    property real spacing: 2
    property int align: 0

    implicitWidth: 212

    anchors {
        right: align === 0
        left: align === 1
        top: true
        bottom: true
    }

    color: 'transparent'

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: root.spacing
    }

}
