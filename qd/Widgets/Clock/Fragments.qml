pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property C.Text hours: C.Text {
        _defaults: root._defaults?.hours ?? null
    }

    readonly property C.Text separator: C.Text {
        _defaults: root._defaults?.separator ?? null
    }

    readonly property C.Text minutes: C.Text {
        _defaults: root._defaults?.minutes ?? null
    }
}
