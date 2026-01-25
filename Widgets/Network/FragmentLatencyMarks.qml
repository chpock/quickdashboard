pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentLatencyMarks _defaults

    readonly property C.Spacing spacing: C.Spacing {
        _defaults: root._defaults?.spacing ?? null
    }

    readonly property C.Padding padding: C.Padding {
        _defaults: root._defaults?.padding ?? null
    }

    readonly property C.Border border: C.Border {
        _defaults: root._defaults?.border ?? null
    }

    property var width: root._defaults?.width

}
