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
import QtQuick
import Quickshell.Services.Mpris

Scope {
    id: root

    readonly property list<MprisPlayer> availablePlayers: Mpris.players.values
    readonly property MprisPlayer activePlayer:
        availablePlayers.find(p => p.isPlaying)
        ?? availablePlayers.find(p => p.canControl && p.canPlay)
        ?? null

    property bool hasPlayer: activePlayer !== null
    property bool isPaused: activePlayer?.playbackState === MprisPlaybackState.Paused
    property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing
    property bool isStopped: activePlayer?.playbackState === MprisPlaybackState.Stopped
    property bool hasLength: hasPlayer && activePlayer.lengthSupported
    property bool hasPosition: hasPlayer && activePlayer.positionSupported
    property bool hasSeek: hasPlayer && activePlayer.canSeek
    property bool hasPlay: hasPlayer && activePlayer.canPlay
    property bool hasPause: hasPlayer && activePlayer.canPause
    property bool hasStop: hasPlayer && activePlayer.canControl
    property bool hasNext: hasPlayer && activePlayer.canGoNext
    property bool hasPrev: hasPlayer && activePlayer.canGoPrevious
    property bool hasToggle: hasPlayer && ((isPlaying && (hasPause || hasStop)) || ((isPaused || isStopped) && hasPlay))
    property bool hasTrackArt: trackArtUrl !== ''
    property bool hasRaise: hasPlayer && activePlayer.canRaise

    readonly property string status:
        !hasPlayer
            ? 'unavailable'
            : isPlaying
                ? 'playing'
                : isPaused
                    ? 'paused'
                    : isStopped
                        ? 'stopped'
                        : 'unknown'

    property int length: hasLength ? Math.round(activePlayer.length) : 0
    property int position: hasPosition ? Math.round(activePlayer.position) : 0
    property string track: activePlayer?.trackTitle || 'Unknown title'
    property string artist: activePlayer?.trackArtist || 'Unknown artist'
    property string trackArtUrl: hasPlayer ? activePlayer.trackArtUrl : ''

    property bool hasService: true

    function play() {
        return hasPlay ? (activePlayer.play() || true) : false
    }

    function pause() {
        return hasPause ? (activePlayer.pause() || true) : false
    }

    function stop() {
        return hasStop ? (activePlayer.stop() || true) : false
    }

    function next() {
        return hasNext ? (activePlayer.next() || true) : false
    }

    function prev() {
        return hasPrev ? (activePlayer.previous() || true) : false
    }

    function pauseOrStop() {
        return hasPause
            ? (activePlayer.pause() || true)
            : hasStop
                ? (activePlayer.stop() || true)
                : false
    }

    function toggle() {
        return isPlaying
            ? pauseOrStop()
            : (isPaused || isStopped)
                ? play()
                : false
    }

    function raise() {
        return hasRaise ? (activePlayer.raise() || true) : false
    }

    Timer {
        running: root.isPlaying && root.hasService
        interval: 1000
        repeat: true
        onTriggered: root.activePlayer.positionChanged()
    }

}
