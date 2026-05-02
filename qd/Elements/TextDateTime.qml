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

Item {
    id: root

    required property C.TextDateTime config
    required property C.Theme theme

    required property date datetime
    property var text
    property var style
    readonly property C.TextDateTime _config: (config._styles_loaded && style && config.getStyle(style)) || config

    implicitHeight: textObj.implicitHeight
    implicitWidth: textObj.implicitWidth

    E.Text {
        id: textObj
        theme: root.theme

        property string datetime: Qt.formatDateTime(root.datetime, root._config.format)
        property string draft: root.text ?? root._config.text
        property bool hasFormat: draft.includes('%1')

        config: C.Text {
            font {
                _defaults: root._config.font
            }
            padding {
                _defaults: root._config.padding
            }
            scroll {
                duration:   0
                pauseStart: 0
                pauseEnd:   0
            }
            alignment {
                _defaults: root._config.alignment
            }
            hover {
                _defaults: root._config.hover
            }
            word_spacing_font_family: root._config.word_spacing_font_family
            background: root._config.background
            overflow:   'none'
            heightMode: root._config.heightMode
            color:      root._config.color
        }
        text: hasFormat ? draft : datetime
        args: hasFormat ? [datetime] : null
        anchors.fill: parent
    }
}
