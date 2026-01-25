pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentRate _defaults

    readonly property FragmentRateItem read: FragmentRateItem {
        _defaults: root._defaults?.read ?? null
    }

    readonly property FragmentRateItem write: FragmentRateItem {
        _defaults: root._defaults?.write ?? null
    }

}
