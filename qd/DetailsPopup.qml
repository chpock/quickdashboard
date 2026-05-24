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
import Quickshell
import qs.qd.Widgets as W

PopupWindow {
    id: root
    visible: false

    required property int dashboardAlign

    // State model:
    // - currentWidget/currentDetails/targetDetails describe the active popup target.
    // - pendingWidget/pendingDetails/hasPendingOpen describe a debounced open request.
    // - queuedWidget/queuedDetails describe a switch request while another details popup
    //   is still visible (close current first, then open queued target).
    // - hasPendingClose + closeDetailsTimer describe a close request that keeps probing
    //   hover state until both widget and popup are no longer hovered.
    // - closeEpoch invalidates stale close probes when a newer open/cancel action wins.
    property W.Base currentWidget: null
    property Component currentDetails: null
    property Component targetDetails: null
    property W.Base queuedWidget: null
    property Component queuedDetails: null
    property W.Base pendingWidget: null
    property Component pendingDetails: null
    property bool hasPendingOpen: false
    property bool hasPendingClose: false
    property int closeEpoch: 0
    property real progress: 0
    property int openDuration: 160
    property int closeDuration: 110
    property int openDebounceInterval: 500
    property int reopenGraceInterval: 500
    property int slideDir: dashboardAlign === Dashboard.AlignRight ? 1 : -1
    property bool isClosing: false
    property bool popupHovered: false
    property double lastCloseTimestamp: -1

    function openDetails(widget, details) {
        cancelCloseDetails()

        if (!widget || !details) {
            cancelDebouncedOpen()
            return
        }

        const nowMs = Date.now()
        const withinReopenGrace = lastCloseTimestamp >= 0
            && nowMs - lastCloseTimestamp <= reopenGraceInterval
        const instantOpen = visible || isClosing || withinReopenGrace

        if (instantOpen) {
            cancelDebouncedOpen()
            openDetailsNow(widget, details)
            return
        }

        queueDebouncedOpen(widget, details)
    }

    function openDetailsNow(widget, details) {
        cancelCloseDetails()

        if (currentWidget === widget && currentDetails === details) {
            clearQueuedTarget()
            isClosing = false
            if (progress < 1.0) {
                progress = 1.0
            }
            showDetailsIfReady()
            return
        }

        if (visible && currentWidget && currentDetails) {
            queuedWidget = widget
            queuedDetails = details
            startCloseTransition()
            return
        }

        isClosing = false
        clearQueuedTarget()
        currentWidget = widget
        targetDetails = details

        progress = 0

        if (visible) {
            visible = false
        }

        if (currentDetails !== details) {
            currentDetails = details
        }

        showDetailsIfReady()
    }

    function closeDetails(widget, widgetHovered) {
        // If the exact widget that had a debounced open request just lost hover,
        // cancel the pending open so it does not open after the pointer already left.
        if (hasPendingOpen && (!widget || widget === pendingWidget)) {
            cancelDebouncedOpen()
        }

        if (!visible) {
            hasPendingClose = false
            closeDetailsTimer.stop()
            return
        }

        // Ignore "some other widget lost hover" notifications.
        // Only the current widget/popup pair can close the active details window.
        if (widget && widget !== currentWidget && widgetHovered === false) {
            return
        }

        // Start/refresh one close request sequence.
        // The timer will keep probing until both hover flags are false.
        hasPendingClose = true
        closeDetailsTimer.epoch = closeEpoch
        closeDetailsTimer.restart()
    }

    function showDetailsIfReady() {
        if (currentDetails !== targetDetails) {
            return
        }
        if (isClosing) {
            return
        }
        if (popupLoader.status !== Loader.Ready) {
            return
        }
        if (!visible) {
            visible = true
        }
        progress = 1.0
    }

    function finalizeCloseTransition() {
        const nextWidget = queuedWidget
        const nextDetails = queuedDetails

        if (visible) {
            visible = false
        }
        currentDetails = null
        targetDetails = null
        isClosing = false
        popupHovered = false
        hasPendingClose = false
        queuedWidget = null
        queuedDetails = null
        lastCloseTimestamp = Date.now()

        if (nextWidget && nextDetails) {
            openDetailsNow(nextWidget, nextDetails)
        }
    }

    function startCloseTransition() {
        isClosing = true

        if (progress <= 0.001) {
            finalizeCloseTransition()
            return
        }

        progress = 0
    }

    function cancelCloseDetails() {
        // Cancel the currently scheduled close sequence.
        // Incrementing closeEpoch invalidates already-armed timer callbacks.
        hasPendingClose = false
        closeEpoch += 1
        closeDetailsTimer.stop()
    }

    function clearQueuedTarget() {
        queuedWidget = null
        queuedDetails = null
    }

    function queueDebouncedOpen(widget, details) {
        // Record deferred open state and arm debounce timer.
        pendingWidget = widget
        pendingDetails = details
        hasPendingOpen = true
        openDebounceTimer.restart()
    }

    function cancelDebouncedOpen() {
        // Clear deferred open state (no delayed open should fire after this point).
        hasPendingOpen = false
        pendingWidget = null
        pendingDetails = null
        openDebounceTimer.stop()
    }

    Behavior on progress {
        NumberAnimation {
            duration: root.isClosing ? root.closeDuration : root.openDuration
            easing.type: root.isClosing ? Easing.InCubic : Easing.OutCubic
        }
    }

    onProgressChanged: {
        if (isClosing && progress <= 0.001) {
            finalizeCloseTransition()
        }
    }

    Timer {
        id: closeDetailsTimer
        interval: 150
        // Snapshot of root.closeEpoch captured when this close probe was scheduled.
        property int epoch: -1
        onTriggered: {
            // Ignore stale probes from older close requests.
            if (epoch != root.closeEpoch || !root.hasPendingClose) {
                return
            }

            const widgetHovered = root.currentWidget
                && root.currentWidget.isHovered === true
            if (root.popupHovered || widgetHovered) {
                // Hover is still active. Keep the same close request alive and check again.
                // Important: do not invalidate closeEpoch here, otherwise the next probe
                // becomes stale and the popup can get stuck visible.
                restart()
                return
            }

            root.hasPendingClose = false
            root.startCloseTransition()
        }
    }

    Timer {
        id: openDebounceTimer
        interval: root.openDebounceInterval
        onTriggered: {
            // Open debounce only executes the latest pending request.
            if (!root.hasPendingOpen || !root.pendingWidget || !root.pendingDetails) {
                return
            }

            const widget = root.pendingWidget
            const details = root.pendingDetails
            const widgetHovered = widget.isHovered === true
            if (!widgetHovered) {
                root.cancelDebouncedOpen()
                return
            }

            root.cancelDebouncedOpen()
            root.openDetailsNow(widget, details)
        }
    }

    anchor.item: root.currentWidget
    grabFocus: false
    color: "transparent"

    anchor {
        // qmllint disable missing-type
        edges:
            (root.dashboardAlign === Dashboard.AlignRight ? Edges.Left : Edges.Right) | Edges.Top
        gravity:
            (root.dashboardAlign === Dashboard.AlignRight ? Edges.Left : Edges.Right) | Edges.Bottom
        adjustment: PopupAdjustment.Slide
        margins.left:
            root.dashboardAlign === Dashboard.AlignRight ? -2 : 0
        margins.right:
            root.dashboardAlign === Dashboard.AlignRight ? 0 : -2
        // qmllint enable missing-type
    }

    implicitWidth: popupLoader.implicitWidth
    implicitHeight: popupLoader.implicitHeight

    HoverHandler {
        onHoveredChanged: {
            root.popupHovered = hovered
            if (hovered) {
                // Entering popup cancels any scheduled close for the current epoch.
                root.cancelCloseDetails()
            } else {
                // Leaving popup starts/refreshes close probing; it will close once both
                // popup and current widget are not hovered.
                root.closeDetails()
            }
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Item {
            width: parent.width
            height: parent.height
            y: 0
            opacity: root.progress
            x: Math.round((1 - root.progress) * root.slideDir * width)

            Loader {
                id: popupLoader
                anchors.fill: parent
                sourceComponent: root.currentDetails
                onStatusChanged: {
                    if (status === Loader.Ready) {
                        root.showDetailsIfReady()
                    }
                }
            }
        }
    }
}
