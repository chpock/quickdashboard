pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentLatency _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.TextSeverity value: C.TextSeverity {
        _defaults: root._defaults.value
    }

    readonly property C.Text details: C.Text {
        _defaults: root._defaults.details
    }

    readonly property FragmentLatencyMarks marks: FragmentLatencyMarks {
        _defaults: root._defaults?.marks ?? null
    }

}
