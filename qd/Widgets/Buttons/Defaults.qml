pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    button {
        _defaults: widget?._defaults.icon
        color: 'white'
        hover {
            enabled: true
        }
        active {
            color: 'info/accent'
        }
    }

    spacing {
        horizontal: 8
    }

}
