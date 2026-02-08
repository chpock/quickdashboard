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
    id: root

    property Thresholds _defaults

    readonly property ThresholdItem ignore: ThresholdItem {
        _defaults: root._defaults?.ignore ?? null
    }
    readonly property ThresholdItem good: ThresholdItem {
        _defaults: root._defaults?.good ?? null
    }
    readonly property ThresholdItem warning: ThresholdItem {
        _defaults: root._defaults?.warning ?? null
    }
    readonly property ThresholdItem critical: ThresholdItem {
        _defaults: root._defaults?.critical ?? null
    }
    property var enabled: root._defaults?.enabled

    readonly property var _severities: ['ignore', 'good', 'warning', 'critical']

    function getSeverity(value: real): ThresholdItem {
        for (let i = 0; i < _severities.length; ++i) {
            const severity = root[_severities[i]]
            const op = severity._op
            if (op === ThresholdItem.OpNone) continue

            const check = severity._value
            switch (op) {
                case ThresholdItem.OpAny:          return severity
                case ThresholdItem.OpEqual:        if (value == check) return severity; break
                case ThresholdItem.OpNotEqual:     if (value != check) return severity; break
                case ThresholdItem.OpGreater:      if (value >  check) return severity; break
                case ThresholdItem.OpGreaterEqual: if (value >= check) return severity; break
                case ThresholdItem.OpLess:         if (value <  check) return severity; break
                case ThresholdItem.OpLessEqual:    if (value <= check) return severity; break
            }
        }
        return null
    }

    function getColor(value: real, theme: Theme): color {
        const severity = Number.isFinite(value) ? getSeverity(value) : root.critical
        if (!severity) return null
        return theme.getColor(severity.color)
    }
}
