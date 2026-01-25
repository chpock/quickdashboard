pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentMount mount: FragmentMount {
        _defaults: root._defaults?.mount ?? null
    }

    readonly property FragmentRate rate: FragmentRate {
        _defaults: root._defaults?.rate ?? null
    }

}
