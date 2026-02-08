/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

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
