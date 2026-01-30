pragma ComponentBehavior: Bound

import qs.qd.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentAlbumArt album_art: FragmentAlbumArt {
        _defaults: root._defaults?.album_art ?? null
    }

    readonly property FragmentPlayer player: FragmentPlayer {
        _defaults: root._defaults?.player ?? null
    }

}
