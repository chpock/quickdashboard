pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentDns _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.Text latency: C.Text {
        _defaults: root._defaults.latency
    }

    readonly property C.TextSeverity status: C.TextSeverity {
        _defaults: root._defaults.status
    }

}
