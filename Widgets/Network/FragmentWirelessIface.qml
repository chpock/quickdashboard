pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property FragmentWirelessIface _defaults

    readonly property C.TextTitle iface: C.TextTitle {
        _defaults: root._defaults.iface
    }

    readonly property C.Text ssid: C.Text {
        _defaults: root._defaults.ssid
    }

    readonly property C.TextPercent signal: C.TextPercent {
        _defaults: root._defaults.signal
    }

}
