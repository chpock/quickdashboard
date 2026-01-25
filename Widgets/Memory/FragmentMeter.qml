pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentMeter _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.TextBytes free: C.TextBytes {
        _defaults: root._defaults.free
    }

    readonly property C.TextBytes total: C.TextBytes {
        _defaults: root._defaults.total
    }

    readonly property C.TextPercent percent: C.TextPercent {
        _defaults: root._defaults.percent
    }

    readonly property C.Bar bar: C.Bar {
        _defaults: root._defaults.bar
    }

}
