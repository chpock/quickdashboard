pragma ComponentBehavior: Bound

import QtQuick

Base {
    property ThemeFontWeight _defaults

    property var normal:     _defaults?.normal
    property var medium:     _defaults?.medium
    property var bold:       _defaults?.bold
    property var extra_bold: _defaults?.extra_bold
    property var black:      _defaults?.black
}
