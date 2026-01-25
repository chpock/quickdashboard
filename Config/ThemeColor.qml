pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property ThemeColor _defaults

    readonly property ThemeColorText text: ThemeColorText {
        _defaults: root._defaults?.text ?? null
    }
    readonly property ThemeColorInfo info: ThemeColorInfo {
        _defaults: root._defaults?.info ?? null
    }
    readonly property ThemeColorSeverity severity: ThemeColorSeverity {
        _defaults: root._defaults?.severity ?? null
    }
}
