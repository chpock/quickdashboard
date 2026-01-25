pragma ComponentBehavior: Bound

import QtQuick

Base {
    id: root

    property Slider _defaults

    readonly property SliderBar bar: SliderBar {
        _defaults: root._defaults?.bar ?? null
    }
    readonly property SliderThumb thumb: SliderThumb {
        _defaults: root._defaults?.thumb ?? null
    }
    readonly property Padding padding: Padding {
        _defaults: root._defaults?.padding ?? null
    }
}
