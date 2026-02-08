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

import qs.qd.Config as C

C.Base {
    id: root

    property FragmentLatency _defaults

    readonly property C.TextTitle title: C.TextTitle {
        _defaults: root._defaults.title
    }

    readonly property C.TextSeverity value: C.TextSeverity {
        _defaults: root._defaults.value
    }

    readonly property C.Text details: C.Text {
        _defaults: root._defaults.details
    }

    readonly property FragmentLatencyMarks marks: FragmentLatencyMarks {
        _defaults: root._defaults?.marks ?? null
    }

}
