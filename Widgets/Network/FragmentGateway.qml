pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentGateway _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.Text details: C.Text {
        _defaults: root._defaults.details
    }

    readonly property C.TextSeverity latency: C.TextSeverity {
        _defaults: root._defaults.latency
    }

}
