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

import Quickshell
import qs.qd.Services as Service

Scope {
    id: root

    readonly property date dateSeconds: Service.SystemClock.dateSeconds
    readonly property date dateMinutes: Service.SystemClock.dateMinutes
    readonly property date dateHours: Service.SystemClock.dateHours
    readonly property date dateDays: Service.SystemClock.dateHours

    readonly property int seconds: dateSeconds.getSeconds()
    readonly property int minutes: dateMinutes.getMinutes()
    readonly property int hours: dateHours.getHours()
}
