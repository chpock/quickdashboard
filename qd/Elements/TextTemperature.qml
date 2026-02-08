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
import qs.qd.Config as C
import '../utils.js' as Utils

Item {
    id: root

    required property C.TextTemperature config
    required property C.Theme theme

    property real value

    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    E.Text {
        id: text
        theme: root.theme
        config: C.Text {
            font {
                _defaults: root.config.font
            }
            padding {
                _defaults: root.config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                _defaults: root.config.alignment
            }
            hover {
                _defaults: root.config.hover
            }
            word_spacing_font_family: root.config.word_spacing_font_family
            background: root.config.background
            overflow:   'none'
            heightMode: root.config.heightMode
            text:       root.config.text
            color:
                root.config.thresholds.enabled
                    ? root.config.thresholds.getColor(root.value, root.theme)
                    : root.config.color
        }

        text: Utils.roundPercent(root.value) + "\u2103"
        anchors.fill: parent
    }
}
