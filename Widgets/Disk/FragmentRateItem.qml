pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentRateItem _defaults

    readonly property C.Text label: C.Text {
        _defaults: root._defaults.label
    }

    readonly property C.TextBytes rate: C.TextBytes {
        _defaults: root._defaults.rate
    }

    readonly property C.GraphTimeseries graph: C.GraphTimeseries {
        _defaults: root._defaults.graph
    }

}
