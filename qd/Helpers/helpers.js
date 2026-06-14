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
        return value.map(item => {
            const plainItem = toPlainValue(item)
            return plainItem === undefined ? null : plainItem
        })
    }

    if (typeof value === 'function') {
        return undefined
    }

    if (typeof value !== 'object') {
        return value
    }

    const result = {}

    for (const prop in value) {
        if (!isExportedProperty(prop)) continue

        const propValue = value[prop]
        if (typeof propValue === 'function') continue

        const plainValue = toPlainValue(propValue)
        if (plainValue === undefined) continue

        result[prop] = plainValue
    }

    return result
}

function isSimpleJsonValue(value) {
    return value === null || value === undefined || typeof value !== 'object'
}

function indent(level) {
    return ' '.repeat(level * 2)
}

function formatJsonValue(value, level) {
    if (Array.isArray(value)) {
        return formatJsonArray(value, level)
    }

    if (!isSimpleJsonValue(value)) {
        return formatJsonObject(value, level)
    }

    const jsonValue = JSON.stringify(value)
    return jsonValue === undefined ? 'null' : jsonValue
}

function formatJsonArray(value, level) {
    if (value.length === 0) {
        return '[]'
    }

    const itemIndent = indent(level + 1)
    const items = value.map(item => `${itemIndent}${formatJsonValue(item, level + 1)}`)

    return `[
${items.join(',\n')}
${indent(level)}]`
}

function formatJsonObject(value, level) {
    const entries = Object.keys(value).map(key => ({ key, value: value[key] }))

    if (entries.length === 0) {
        return '{}'
    }

    const simpleEntries = []
    const arrayEntries = []
    const objectEntries = []

    for (const entry of entries) {
        if (Array.isArray(entry.value)) {
            arrayEntries.push(entry)
        } else if (isSimpleJsonValue(entry.value)) {
            simpleEntries.push(entry)
        } else {
            objectEntries.push(entry)
        }
    }

    const orderedEntries = [...simpleEntries, ...arrayEntries, ...objectEntries]
    const keyIndent = indent(level + 1)
    const alignedKeyWidth = simpleEntries.reduce((maxWidth, entry) => {
        return Math.max(maxWidth, JSON.stringify(entry.key).length)
    }, 0)
    const formattedEntries = []

    for (const entry of orderedEntries) {
        const key = JSON.stringify(entry.key)
        const formattedValue = formatJsonValue(entry.value, level + 1)
        const isSimpleEntry = isSimpleJsonValue(entry.value)
        let formattedEntry

        if (isSimpleEntry) {
            const padding = ' '.repeat(alignedKeyWidth - key.length)
            formattedEntry = `${keyIndent}${key}${padding} : ${formattedValue}`
        } else {
            formattedEntry = `${keyIndent}${key}: ${formattedValue}`
        }

        if (!isSimpleEntry && formattedEntries.length > 0) {
            formattedEntry = `\n${formattedEntry}`
        }

        formattedEntries.push(formattedEntry)
    }

    return `{
${formattedEntries.join(',\n')}
${indent(level)}}`
}

function toPrettyJson(value) {
    return formatJsonValue(toPlainValue(value), 0)
}
