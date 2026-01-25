pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentRate _defaults

    readonly property FragmentRateItem download: FragmentRateItem {
        _defaults: root._defaults?.download ?? null
    }

    readonly property FragmentRateItem upload: FragmentRateItem {
        _defaults: root._defaults?.upload ?? null
    }

}
