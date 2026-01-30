pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property C.Icon button: C.Icon {
        _defaults: root._defaults?.button ?? null
    }
    readonly property C.Spacing spacing: C.Spacing {
        _defaults: root._defaults?.spacing ?? null
    }
}
