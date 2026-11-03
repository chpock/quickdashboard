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

    property real valueMax: 100.0
    property real value: 0
    // Desired current value; null/undefined omit the target indicator and its space.
    property var valueTarget: null

    readonly property real effectiveWidth: Math.max(0, width - root.config.padding.left - root.config.padding.right)

    implicitHeight: config.height + config.padding._vertical + targetIndicator.implicitHeight

    // Active segment: the actual value.
    Rectangle {
        id: foreground

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        height: root.config.height
        width: root.valueMax <= 0 ? 0 : root.effectiveWidth * root.value / root.valueMax
        color: root.theme.getColor(root.config.color.active)
    }

    // Inactive segment: the remaining range above the actual value.
    Rectangle {
        anchors.left: foreground.right
        anchors.top: foreground.top
        height: root.config.height
        width: Math.max(0, root.effectiveWidth - foreground.width)
        color: root.theme.getColor(root.config.color.inactive)
    }

    // Target indicator spans actual and desired values on the main bar's scale.
    // Keep its space when values coincide to prevent layout jumps.
    Rectangle {
        id: targetIndicator

        readonly property bool _hasTarget: root.valueTarget !== null && root.valueTarget !== undefined
        readonly property real targetPosition:
            !_hasTarget || root.valueMax <= 0 ? foreground.width : root.effectiveWidth * root.valueTarget / root.valueMax

        implicitHeight: _hasTarget ? root.config.target.height + root.config.target.padding._vertical : 0
        visible: _hasTarget && width > 0
        x: foreground.x + Math.min(foreground.width, targetPosition)
        anchors.top: foreground.bottom
        anchors.topMargin: root.config.target.padding.top
        width: Math.abs(foreground.width - targetPosition)
        height: root.config.target.height
        color: root.theme.getColor(
            root.value > root.valueTarget
                ? root.config.target.color.above
                : root.config.target.color.below
        )
    }
}
