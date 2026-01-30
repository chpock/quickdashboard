pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentGraph _defaults

    readonly property C.GraphTimeseries cpu_usage: C.GraphTimeseries {
        _defaults: root._defaults.cpu_usage
    }

    readonly property C.GraphBars cores_usage: C.GraphBars {
        _defaults: root._defaults.cores_usage
    }

}
