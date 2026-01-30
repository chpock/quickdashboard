pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property Widget _defaults

    readonly property WidgetBorder border: WidgetBorder {
        _defaults: root._defaults?.border ?? null
    }
    readonly property WidgetBackground background: WidgetBackground {
        _defaults: root._defaults?.background ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
    readonly property Spacing spacing: Spacing {
        _defaults: root._defaults?.spacing ?? null
    }
}
