pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property C.Icon icon: C.Icon {
        _defaults: root._defaults?.icon ?? null
    }
    readonly property C.Icon indicator: C.Icon {
        _defaults: root._defaults?.indicator ?? null
    }
    readonly property C.Text device: C.Text {
        _defaults: root._defaults?.device ?? null
    }
    readonly property C.TextPercent percent: C.TextPercent {
        _defaults: root._defaults?.percent ?? null
    }
    readonly property C.Slider slider: C.Slider {
        _defaults: root._defaults?.slider ?? null
    }
}
