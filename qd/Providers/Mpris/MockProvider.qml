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

Provider {
    id: root

    hasService: false

    length: 189
    position: 145
    track: 'Code Monkey'
    artist: 'Jonathan Coulton'
    trackArtUrl: 'https://i.scdn.co/image/ab67616d0000b273dfd5b5d99cf81f1864deef01'

    hasPlayer: true
    isPaused: false
    isPlaying: true
    isStopped: false
    hasLength: true
    hasPosition: true
    hasSeek: true
    hasPlay: true
    hasPause: true
    hasStop: true
    hasNext: true
    hasPrev: true
    hasToggle: true
    hasRaise: true
}
