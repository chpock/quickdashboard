pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentCalendar _defaults

    readonly property FragmentCalendarHeader header: FragmentCalendarHeader {
        _defaults: root._defaults?.header ?? null
    }
    readonly property C.Spacing spacing: C.Spacing {
        _defaults: root._defaults?.spacing ?? null
    }
    readonly property C.Text cell: C.Text {
        _defaults: root._defaults?.cell ?? null
    }
    readonly property FragmentCalendarHover hover: FragmentCalendarHover {
        _defaults: root._defaults?.hover ?? null
    }

    property var weekday_names: root._defaults?.weekday_names
}
