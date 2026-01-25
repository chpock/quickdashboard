pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property Config _defaults

    readonly property Widget widget: Widget {
        _defaults: root._defaults?.widget ?? null
    }
    readonly property Theme theme: Theme {
        _defaults: root._defaults?.theme ?? null
    }
    readonly property Defaults defaults: Defaults {
        _defaults: root._defaults?.defaults ?? null
    }

    property QtObject fragments

}
