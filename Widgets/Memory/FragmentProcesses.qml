pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentProcesses _defaults

    readonly property C.ProcessList list: C.ProcessList {
        _defaults: root._defaults.list
    }

    readonly property C.TextBytes value: C.TextBytes {
        _defaults: root._defaults.value
    }

}
