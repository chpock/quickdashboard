pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentProcesses _defaults

    readonly property C.ProcessList list: C.ProcessList {
        _defaults: root._defaults.list
    }

    readonly property C.TextPercent value: C.TextPercent {
        _defaults: root._defaults.value
    }

}
