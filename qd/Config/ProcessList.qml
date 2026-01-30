pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

Base {
    id: root

    property ProcessList _defaults

    readonly property C.Text common: C.Text {
        _defaults: root._defaults?.common ?? null
    }
    readonly property C.Text command: C.Text {
        _defaults: root._defaults?.command ?? null
    }
    readonly property C.Text args: C.Text {
        _defaults: root._defaults?.args ?? null
    }
    readonly property C.Text value: C.Text {
        _defaults: root._defaults?.value ?? null
    }
    readonly property Spacing spacing: Spacing {
        _defaults: root._defaults?.spacing ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
}
