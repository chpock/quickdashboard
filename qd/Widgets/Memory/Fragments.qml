pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentMeter meter: FragmentMeter {
        _defaults: root._defaults?.meter ?? null
    }

    readonly property FragmentProcesses processes: FragmentProcesses {
        _defaults: root._defaults?.processes ?? null
    }

}
