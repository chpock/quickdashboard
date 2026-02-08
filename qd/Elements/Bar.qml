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
import qs.qd.Config as C

Item {
    id: root

    required property C.Bar config
    required property C.Theme theme

    property real maxValue: 100.0
    property real value: 0

    readonly property real effectiveWidth: Math.max(0, width - root.config.padding.left - root.config.padding.right)

    implicitHeight: config.height + config.padding.top + config.padding.bottom

    // Background (empty part)
    Rectangle {
        id: background

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.right: parent.right
        anchors.rightMargin: root.config.padding.right
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        height: root.config.height
        color: root.theme.getColor(root.config.color.inactive)
    }

    // Foreground (filled part)
    Rectangle {
        id: foreground

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        height: root.config.height
        width:
            root.maxValue <= 0
                ? 0
                : root.effectiveWidth * root.value / root.maxValue
        color: root.theme.getColor(root.config.color.active)
    }
}
