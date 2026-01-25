pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property ThemeFont _defaults

    readonly property ThemeFontFamily family: ThemeFontFamily {
        _defaults: root._defaults?.family ?? null
    }
    readonly property ThemeFontSize size: ThemeFontSize {
        _defaults: root._defaults?.size ?? null
    }
    readonly property ThemeFontWeight weight: ThemeFontWeight {
        _defaults: root._defaults?.weight ?? null
    }
}
