pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentPlayerControl _defaults

    readonly property C.Icon button: C.Icon {
        _defaults: root._defaults.button
    }

    readonly property C.Spacing spacing: C.Spacing {
        _defaults: root._defaults?.spacing ?? null
    }

    readonly property C.Padding padding: C.Padding {
        _defaults: root._defaults?.padding ?? null
    }

}
