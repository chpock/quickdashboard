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

    property FragmentPlayerControl _defaults

    readonly property C.Icon button: C.Icon {
        _defaults: root._defaults.button
    }

    readonly property C.Spacing spacing: C.Spacing {
        _defaults: root._defaults?.spacing ?? null
    }

    readonly property C.Padding padding: C.Padding {
        _defaults: root._defaults?.padding ?? null
    }

}
