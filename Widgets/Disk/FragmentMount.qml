pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentMount _defaults

    readonly property C.TextTitle point: C.TextTitle {
        _defaults: root._defaults.point
    }

    readonly property C.TextPercent used: C.TextPercent {
        _defaults: root._defaults.used
    }

    readonly property C.Text details: C.Text {
        _defaults: root._defaults.details
    }

    readonly property C.TextBytes free: C.TextBytes {
        _defaults: root._defaults.free
    }

    readonly property C.TextBytes total: C.TextBytes {
        _defaults: root._defaults.total
    }

    readonly property C.Bar bar: C.Bar {
        _defaults: root._defaults.bar
    }

}
