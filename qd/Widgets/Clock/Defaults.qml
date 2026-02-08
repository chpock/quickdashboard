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

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    hours {
        _defaults: widget._defaults.text
        font {
            size:   40
            weight: 'bold'
        }
        heightMode: 'capitals'
    }

    separator {
        _defaults: widget._defaults.text
        font {
            size: 40
        }
        padding {
            top:   -3
            left:  5
            right: 5
        }
        heightMode: 'capitals'
        text: ':'
    }

    minutes {
        _defaults: widget._defaults.text
        font {
            size: 40
        }
        heightMode: 'capitals'
    }

}
