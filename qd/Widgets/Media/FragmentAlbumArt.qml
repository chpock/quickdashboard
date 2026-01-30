pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentAlbumArt _defaults

    readonly property C.Padding padding: C.Padding {
        _defaults: root._defaults?.padding ?? null
    }

    readonly property C.Size size: C.Size {
        _defaults: root._defaults?.size ?? null
    }

    readonly property C.Border border: C.Border {
        _defaults: root._defaults?.border ?? null
    }

    readonly property C.Icon no_art: C.Icon {
        _defaults: root._defaults.no_art
    }

}
