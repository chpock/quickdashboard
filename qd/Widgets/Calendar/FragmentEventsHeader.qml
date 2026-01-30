pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentEventsHeader _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root?._defaults.title ?? null
    }
    readonly property C.Icon button: C.Icon {
        _defaults: root?._defaults.button ?? null
    }
}
