pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentMeter _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.TextTemperature temperature: C.TextTemperature {
        _defaults: root._defaults.temperature
    }

    readonly property C.TextPercent percent: C.TextPercent {
        _defaults: root._defaults.percent
    }

    readonly property C.Bar bar: C.Bar {
        _defaults: root._defaults.bar
    }

}
