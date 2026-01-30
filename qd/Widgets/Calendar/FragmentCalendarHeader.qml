pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentCalendarHeader _defaults

    readonly property C.Icon icon: C.Icon {
        _defaults: root._defaults?.icon ?? null
    }
    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults?.title ?? null
    }

}
