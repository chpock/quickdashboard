pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentCalendarHover _defaults

    readonly property C.Border border: C.Border {
        _defaults: root._defaults?.border ?? null
    }
}
