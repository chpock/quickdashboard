pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentPlayer _defaults

    readonly property C.Text status: C.Text {
        _defaults: root._defaults.status
    }

    readonly property C.Text time: C.Text {
        _defaults: root._defaults.time
    }

    readonly property FragmentPlayerControl control: FragmentPlayerControl {
        _defaults: root._defaults?.control ?? null
    }

    readonly property C.Slider slider: C.Slider {
        _defaults: root._defaults.slider
    }

    readonly property C.Text track: C.Text {
        _defaults: root._defaults.track
    }

    readonly property C.Text artist: C.Text {
        _defaults: root._defaults.artist
    }

}
