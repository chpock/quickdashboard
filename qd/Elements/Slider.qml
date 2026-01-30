pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

Item {
    id: root

    required property C.Slider config
    required property C.Theme theme

    property real maxValue: 100.0
    property real value: 0
    property bool canSeek: true
    property real mouseWheelResolution: 5
    property real touchpadResolution: 0.03

    signal slide(real offset)

    property bool isHovered: false
    readonly property bool isThumbActive: isHovered || drag.active
    readonly property real effectiveWidth: Math.max(0, width - root.config.padding.left - root.config.padding.right)

    implicitHeight: Math.max(root.config.thumb.height, root.config.bar.height) +
        root.config.padding.top + root.config.padding.bottom

    // Background (empty part)
    Rectangle {
        id: background

        readonly property real topMargin: root.config.padding.top +
            Math.max(0, root.config.thumb.height - root.config.bar.height) / 2

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.right: parent.right
        anchors.rightMargin: root.config.padding.right
        anchors.top: parent.top
        anchors.topMargin: topMargin
        height: root.config.bar.height
        color: root.theme.getColor(root.config.bar.color.inactive)
    }

    // Foreground (filled part)
    Rectangle {
        id: foreground

        readonly property real thumbWidth:
            root.isThumbActive
                ? root.config.thumb.width + root.config.thumb.gap
                : 0

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.top: parent.top
        anchors.topMargin: background.topMargin
        height: root.config.bar.height
        width:
            root.maxValue <= 0
                ? 0
                : (root.effectiveWidth - thumbWidth) * root.value / root.maxValue
        color: root.theme.getColor(root.config.bar.color.active)
    }

    Rectangle {
        id: thumb

        anchors.left: foreground.right
        anchors.leftMargin: foreground.width >= 1 ? root.config.thumb.gap : 0
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root.config.padding.bottom
        width: root.config.thumb.width
        color: root.theme.getColor(root.config.thumb.color)
        visible: root.isThumbActive
    }

    HoverHandler {
        id: hoverHandler

        enabled: root.canSeek
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor

        onHoveredChanged: {
            if (hovered) {
                thumbHide.stop()
                root.isHovered = true
            } else {
                thumbHide.start()
            }
        }
    }

    TapHandler {
        enabled: root.canSeek
        acceptedButtons: Qt.LeftButton
        gesturePolicy: TapHandler.WithinBounds

        onTapped: point => {
            const slide =
                root.effectiveWidth === 0
                    ? 0
                    : Math.max(0, Math.min(root.effectiveWidth, point.position.x - root.config.padding.left)) / root.effectiveWidth
            root.slide(slide * root.maxValue)
        }
    }

    DragHandler {
        id: drag

        enabled: root.canSeek
        target: null

        onTranslationChanged: {
            const slide =
                root.effectiveWidth === 0
                    ? 0
                    : Math.max(0, Math.min(root.effectiveWidth, centroid.position.x)) / root.effectiveWidth
            root.slide(slide * root.maxValue)
        }
    }

    WheelHandler {
        enabled: root.canSeek
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad

        onWheel: event => root.wheelHandler(event)
    }

    Timer {
        id: thumbHide

        interval: 250
        running: false
        repeat: false

        onTriggered: {
            root.isHovered = false
        }
    }

    function wheelHandler(event) {
        const deltaY = event.angleDelta.y
        const isMouseWheel = Math.abs(deltaY) >= 120 && deltaY % 120 === 0
        const deltaRel =
            isMouseWheel
                ? mouseWheelResolution * deltaY / 120
                : touchpadResolution * deltaY
        const deltaAbs = root.maxValue * deltaRel / 100
        const slide = Math.max(0, Math.min(root.maxValue, root.value + deltaAbs))
        event.accepted = true
        root.slide(slide)
    }

}
