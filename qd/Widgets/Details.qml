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

Rectangle {
    id: root

    required property Base base

    readonly property C.Theme _theme: base._theme
    readonly property C.Defaults _defaults: base._defaults
    readonly property C.Widget _widget: base._widget

    default property alias content: content.data

    border {
        color: _theme.getColor(_widget.border.color)
        width: _widget.border.width
    }

    color: _theme.getColor(_widget.background.color)

    implicitHeight: content.implicitHeight
        + _widget.padding.top + _widget.padding.bottom
        + _widget.border.width * 2

    Column {
        id: content
        y:             root._widget.padding.left + root._widget.border.width
        spacing:       root._widget.spacing.vertical
        width:         parent.width
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.leftMargin:   root._widget.padding.left   + root._widget.border.width
        anchors.rightMargin:  root._widget.padding.right  + root._widget.border.width
        anchors.topMargin:    root._widget.padding.top    + root._widget.border.width
        anchors.bottomMargin: root._widget.padding.bottom + root._widget.border.width
    }
}
