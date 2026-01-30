pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentEvents _defaults

    readonly property FragmentEventsHeader header: FragmentEventsHeader {
        _defaults: root._defaults?.header ?? null
    }
    readonly property C.Icon icon: C.Icon {
        _defaults: root._defaults?.icon ?? null
    }
    readonly property C.Text title: C.Text {
        _defaults: root._defaults?.title ?? null
    }
    readonly property C.Text marker: C.Text {
        _defaults: root._defaults?.marker ?? null
    }
    readonly property C.Icon hide: C.Icon {
        _defaults: root._defaults?.hide ?? null
    }
    readonly property C.Text details: C.Text {
        _defaults: root._defaults?.details ?? null
    }
    readonly property C.Text timer: C.Text {
        _defaults: root._defaults?.timer ?? null
    }

    property var alarm_offset_seconds: root._defaults?.alarm_offset_seconds
    property var far_in_future_offset_seconds: root._defaults?.far_in_future_offset_seconds
}
