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
import qs.qd.Providers as Providers

Item {
    id: root

    required property C.TextDuration config
    required property C.Theme theme

    property var text
    property var style
    readonly property C.TextDuration _config: (config._styles_loaded && style && config.getStyle(style)) || config

    property int seconds: {
        const result = (targetDate.getTime() - baseDate.getTime()) / 10 ** 3
        return (!allowNegative && result < 0) ? 0 : result
    }
    property var targetDate: null
    // qmllint disable missing-property
    property date baseDate: Providers.SystemClock.instance.dateSeconds
    // qmllint enable missing-property
    property bool allowNegative: true

    implicitHeight: textObj.implicitHeight
    implicitWidth: textObj.implicitWidth

    E.Text {
        id: textObj
        theme: root.theme

        property string duration: {
            const sign = root.seconds < 0 ? '-' : ''
            const delta = Math.abs(root.seconds)
            const days = Math.floor(delta / 86400)
            const hours = Math.floor((delta % 86400) / 3600)
            if (days > 0) {
                const result = sign + days + 'd'
                return hours <= 0 ? result : (result + ' ' + hours + 'h')
            }
            const minutes = Math.floor((delta % 3600) / 60)
            if (hours > 0) {
                const result = sign + hours + 'h'
                return minutes <= 0 ? result : (result + ' ' + minutes + 'm')
            }
            if (minutes > 9) {
                return sign + minutes + 'm'
            }
            const seconds = delta % 60
            if (minutes > 0) {
                const result = sign + minutes + 'm'
                return seconds <= 0 ? result : (result + ' ' + seconds + 's')
            }
            return sign + seconds + 's'
        }
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
            color:
                root._config.thresholds.enabled
                    ? root._config.thresholds.getColor(root.seconds, root.theme)
                    : root._config.color
        }
        text: hasFormat ? draft : duration
        args: hasFormat ? [duration] : null
        anchors.fill: parent
    }
}
