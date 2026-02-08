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
import qs.qd.Elements as E
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    readonly property var providerSystemClock: Provider.SystemClock.instance

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    Item {
        id: clock

        readonly property var config: root._fragments

        implicitHeight: Math.max(hours.implicitHeight, separator.implicitHeight, minutes.implicitHeight)
        implicitWidth: hours.implicitWidth + separator.implicitWidth + minutes.implicitWidth
        anchors.horizontalCenter: parent.horizontalCenter

        E.Text {
            id: hours
            theme: root._theme
            config: clock.config.hours

            text: Qt.formatDateTime(root.providerSystemClock.dateMinutes, "hh")
            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.Text {
            id: separator
            theme: root._theme
            config: clock.config.separator

            anchors.left: hours.right
            anchors.top: parent.top
        }

        E.Text {
            id: minutes
            theme: root._theme
            config: clock.config.minutes

            text: Qt.formatDateTime(root.providerSystemClock.dateMinutes, "mm")
            anchors.left: separator.right
            anchors.top: parent.top
        }

    }

}
