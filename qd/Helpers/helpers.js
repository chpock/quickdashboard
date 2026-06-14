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

function isExportedProperty(prop) {
    return prop !== 'objectName' && !prop.startsWith('_') && !prop.endsWith('Changed')
}

function toPlainValue(value) {
    if (value === null || value === undefined) {
        return value
    }

    if (Array.isArray(value)) {
        return value.map(item => toPlainValue(item))
    }

    if (typeof value !== 'object') {
        return value
    }

    const result = {}

    for (const prop in value) {
        if (!isExportedProperty(prop)) continue

        const propValue = value[prop]
        if (typeof propValue === 'function') continue

        result[prop] = toPlainValue(propValue)
    }

    return result
}

function toPrettyJson(value) {
    return JSON.stringify(toPlainValue(value), null, 4)
}
