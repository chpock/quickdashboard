pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property list<MprisPlayer> availablePlayers: Mpris.players.values
    readonly property MprisPlayer activePlayer:
        availablePlayers.find(p => p.isPlaying)
        ?? availablePlayers.find(p => p.canControl && p.canPlay)
        ?? null

    readonly property bool hasPlayer: activePlayer !== null
    readonly property bool isPaused: activePlayer?.playbackState === MprisPlaybackState.Paused
    readonly property bool isPlaying: activePlayer?.playbackState === MprisPlaybackState.Playing
    readonly property bool isStopped: activePlayer?.playbackState === MprisPlaybackState.Stopped
    readonly property bool hasLength: hasPlayer && activePlayer.lengthSupported
    readonly property bool hasPosition: hasPlayer && activePlayer.positionSupported
    readonly property bool hasSeek: hasPlayer && activePlayer.canSeek
    readonly property bool hasPlay: hasPlayer && activePlayer.canPlay
    readonly property bool hasPause: hasPlayer && activePlayer.canPause
    readonly property bool hasStop: hasPlayer && activePlayer.canControl
    readonly property bool hasNext: hasPlayer && activePlayer.canGoNext
    readonly property bool hasPrev: hasPlayer && activePlayer.canGoPrevious
    readonly property bool hasToggle: hasPlayer && ((isPlaying && (hasPause || hasStop)) || ((isPaused || isStopped) && hasPlay))
    readonly property bool hasTrackArt: trackArtUrl !== ''
    readonly property bool hasRaise: hasPlayer && activePlayer.canRaise

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

    readonly property int length: hasLength ? Math.round(activePlayer.length) : 0
    readonly property int position: hasPosition ? Math.round(activePlayer.position) : 0
    readonly property string track: activePlayer?.trackTitle || 'Unknown title'
    readonly property string artist: activePlayer?.trackArtist || 'Unknown artist'
    readonly property string trackArtUrl: hasPlayer ? activePlayer.trackArtUrl : ''

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
        running: root.isPlaying
        interval: 1000
        repeat: true
        onTriggered: root.activePlayer.positionChanged()
    }

}
