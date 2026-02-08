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
