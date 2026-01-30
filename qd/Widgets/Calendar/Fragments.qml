pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentCalendar calendar: FragmentCalendar {
        _defaults: root._defaults?.calendar ?? null
    }

    readonly property FragmentEvents events: FragmentEvents {
        _defaults: root._defaults?.events ?? null
    }

}
