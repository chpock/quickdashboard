pragma ComponentBehavior: Bound

import qs.Config as C

C.Base {
    id: root

    property Fragments _defaults

    readonly property FragmentWirelessIface wireless_iface: FragmentWirelessIface {
        _defaults: root._defaults?.wireless_iface ?? null
    }

    readonly property FragmentLatency latency: FragmentLatency {
        _defaults: root._defaults?.latency ?? null
    }

    readonly property FragmentDns dns: FragmentDns {
        _defaults: root._defaults?.dns ?? null
    }

    readonly property FragmentGateway gateway: FragmentGateway {
        _defaults: root._defaults?.gateway ?? null
    }

    readonly property FragmentRate rate: FragmentRate {
        _defaults: root._defaults?.rate ?? null
    }

}
