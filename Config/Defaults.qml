pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C

Base {
    id: root

    property Defaults _defaults

    readonly property Slider slider: Slider {
        _defaults: root._defaults?.slider ?? null
    }
    readonly property Bar bar: Bar {
        _defaults: root._defaults?.bar ?? null
    }
    readonly property C.Text text: C.Text {
        _defaults: root._defaults?.text ?? null
    }
    readonly property TextTitle text_title: TextTitle {
        _defaults: root._defaults?.text_title ?? null
    }
    readonly property TextTemperature text_temperature: TextTemperature {
        _defaults: root._defaults?.text_temperature ?? null
    }
    readonly property TextPercent text_percent: TextPercent {
        _defaults: root._defaults?.text_percent ?? null
    }
    readonly property TextSeverity text_severity: TextSeverity {
        _defaults: root._defaults?.text_severity ?? null
    }
    readonly property TextBytes text_bytes: TextBytes {
        _defaults: root._defaults?.text_bytes ?? null
    }
    readonly property Icon icon: Icon {
        _defaults: root._defaults?.icon ?? null
    }
    readonly property GraphTimeseries graph_timeseries: GraphTimeseries {
        _defaults: root._defaults?.graph_timeseries ?? null
    }
    readonly property GraphBars graph_bars: GraphBars {
        _defaults: root._defaults?.graph_bars ?? null
    }
    readonly property ProcessList process_list: ProcessList {
        _defaults: root._defaults?.process_list ?? null
    }
}
