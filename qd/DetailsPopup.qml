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

    property W.Base currentWidget: null
    property Component currentDetails: null
    property Component targetDetails: null
    property W.Base queuedWidget: null
    property Component queuedDetails: null
    property int closeEpoch: 0
    property real progress: 0
    property int openDuration: 160
    property int closeDuration: 110
    property int slideDir: dashboardAlign === Dashboard.AlignRight ? 1 : -1
    property bool isClosing: false
    property bool popupHovered: false

    function openDetails(widget, details) {
        cancelCloseDetails()
        const sameTarget = currentWidget === widget
            && currentDetails === details

        if (sameTarget) {
            queuedWidget = null
            queuedDetails = null
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
            if (!isClosing) {
                isClosing = true
                progress = 0
            }
            return
        }

        isClosing = false
        queuedWidget = null
        queuedDetails = null
        currentWidget = widget
        targetDetails = details

        progress = 0

        if (visible) {
            visible = false
        }

        if (currentDetails !== targetDetails) {
            currentDetails = targetDetails
        }

        showDetailsIfReady()
    }

    function closeDetails(widget, widgetHovered) {
        if (!visible) {
            return
        }
        if (widget && widget !== currentWidget && widgetHovered === false) {
            return
        }
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

    function cancelCloseDetails() {
        closeEpoch += 1
        closeDetailsTimer.stop()
    }

    Behavior on progress {
        NumberAnimation {
            duration: root.isClosing ? root.closeDuration : root.openDuration
            easing.type: root.isClosing ? Easing.InCubic : Easing.OutCubic
        }
    }

    onProgressChanged: {
        if (isClosing && progress <= 0.001) {
            const nextWidget = queuedWidget
            const nextDetails = queuedDetails

            visible = false
            currentDetails = null
            targetDetails = null
            isClosing = false
            popupHovered = false
            queuedWidget = null
            queuedDetails = null

            if (nextWidget && nextDetails) {
                openDetails(nextWidget, nextDetails)
            }
        }
    }

    Timer {
        id: closeDetailsTimer
        interval: 150
        property int epoch: -1
        onTriggered: {
            if (epoch != root.closeEpoch) {
                return
            }

            const widgetHovered = root.currentWidget
                && root.currentWidget.isHovered === true
            if (root.popupHovered || widgetHovered) {
                root.cancelCloseDetails()
                return
            }

            root.isClosing = true
            root.progress = 0
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
                root.cancelCloseDetails()
            } else {
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
