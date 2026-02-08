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
import qs.qd.Elements as E

Item {
    id: root

    required property C.Icon config
    required property C.Theme theme

    property var icon
    property var style
    readonly property C.Icon _config: (config._styles_loaded && style && config.getStyle(style)) || config

    property bool isActive

    readonly property real fill: _config.filled ? 1.0 : 0.0

    implicitWidth: text.implicitWidth
    implicitHeight: text.implicitHeight

    signal clicked()

    E.Text {
        id: text

        theme: root.theme
        config: C.Text {
            font {
                _defaults: root._config.font
            }
            overflow:   C.Text.OverflowNone
            heightMode: C.Text.HeightNormal
            padding {
                _defaults: root._config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                horizontal: Text.AlignHCenter
                vertical:   Text.AlignVCenter
            }
            hover {
                enabled: root._config.hover.enabled
            }
            word_spacing_font_family: root._config.word_spacing_font_family
            color: root._config.color
            background: root._config.background
            styles: ({
                hover: {
                    color: root._config.hover.color,
                },
                active: {
                    color: root._config.active.color,
                },
            })
        }

        text: root.icon == null ? root._config.icon : root.icon
        style:
            isHovered
                ? 'hover'
                : root.isActive
                    ? 'active'
                    : undefined
        // // heightMode: E.Text.Content
        anchors.fill: parent
        antialiasing: true
        fontVariableAxes: ({
            "FILL": root.fill.toFixed(1),
            "GRAD": root._config.grade,
            "opsz": root._config.opticalSize,
            "wght": root._config.weight,
        })
    }

    TapHandler {
        onTapped: root.clicked()
    }
}
