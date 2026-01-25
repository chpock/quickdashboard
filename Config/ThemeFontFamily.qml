pragma ComponentBehavior: Bound

import QtQuick

Base {
    property ThemeFontFamily _defaults

    property var general: _defaults?.general
    property var symbols: _defaults?.symbols
}
