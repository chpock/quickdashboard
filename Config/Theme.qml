pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    readonly property ThemePalette palette: ThemePalette {}
    readonly property ThemeColor color: ThemeColor {}
    readonly property ThemeFont font: ThemeFont {}

    function getColor(value) {
        if (typeof value === 'string') {
            let alpha = 1.0
            const idx = value.indexOf('%')
            if (idx !== -1 && value.indexOf('%', idx + 1) === -1) {
                const alpha_str = value.substring(idx + 1)
                const alpha_maybe = parseFloat(alpha_str)
                if (isNaN(alpha_maybe)) {
                    console.log('got NaN as alpha_maybe from:', alpha_str)
                } else {
                    alpha = alpha_maybe / 100.0
                }
                value = value.substring(0, idx)
            }
            if (value in root.palette) {
                value = root.palette[value]
            } else {
                const idx = value.indexOf('/')
                if (idx !== -1 && value.indexOf('/', idx + 1) === -1) {
                    var colorKind = value.substring(0, idx)
                    var colorName = value.substring(idx + 1)
                    if (colorKind in root.color && colorName in root.color[colorKind]) {
                        value = root.color[colorKind][colorName]
                    }
                }
            }
            if (alpha !== 1.0) {
                const color = Qt.color(value)
                value = Qt.rgba(color.r, color.g, color.b, alpha)
            }
        }
        return value
    }

    function getFontSize(value) {
        if (typeof value === 'string' && value in root.font.size) {
            return root.font.size[value]
        }
        return value
    }

    function getFontFamily(value) {
        if (typeof value === 'string' && value in root.font.family) {
            return root.font.family[value]
        }
        return value
    }

    function getFontWeight(value) {
        if (typeof value === 'string' && value in root.font.weight) {
            return root.font.weight[value]
        }
        return value
    }
}
