pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentMeter meter: FragmentMeter {
        _defaults: root._defaults?.meter ?? null
    }

    readonly property FragmentGraph graph: FragmentGraph {
        _defaults: root._defaults?.graph ?? null
    }

    readonly property FragmentProcesses processes: FragmentProcesses {
        _defaults: root._defaults?.processes ?? null
    }

}
