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

    enum Operator {
        OpNone         = 0,
        OpEqual        = 1,
        OpNotEqual     = 2,
        OpGreater      = 3,
        OpGreaterEqual = 4,
        OpLess         = 5,
        OpLessEqual    = 6,
        OpAny          = 7
    }

    property ThresholdItem _defaults

    property var color: _defaults?.color
    property var value: _defaults?.value

    readonly property int _op: {
        if (value == null || typeof value !== 'string') return ThresholdItem.OpNone
        if (value === 'none' || value === 'skip' || value === '') return ThresholdItem.OpNone
        if (value === 'any') return ThresholdItem.OpAny
        switch (value[0]) {
            case '=': return ThresholdItem.OpEqual
            case '!': return ThresholdItem.OpNotEqual
            case '>': return value[1] === '=' ? ThresholdItem.OpGreaterEqual : ThresholdItem.OpGreater
            case '<': return value[1] === '=' ? ThresholdItem.OpLessEqual : ThresholdItem.OpLess
        }
        console.error('unable to parse op from value:', value)
        return ThresholdItem.OpNone
    }

    readonly property real _value: {
        if (typeof value === 'string') {
            let idx = 0
            while (['=', '!', '>', '<', ' '].includes(value[idx])) ++idx
            const value_cut = idx === 0 ? value : value.substring(idx)
            switch (value_cut) {
                case '-Inf': return Number.NEGATIVE_INFINITY
                case 'Inf': return Number.POSITIVE_INFINITY
                default: return parseFloat(value_cut)
            }
        }
        return value
    }
}
