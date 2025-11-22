pragma ComponentBehavior: Bound

import QtQuick
import qs

Item {
    id: root

    property color color: Theme.slider.color.active

    property real maxValue: 100.0
    property real value: 0
    property bool canSeek: true
    property real mouseWheelResolution: 5
    property real touchpadResolution: 0.03

    signal slide(real offset)

    readonly property real barHeight: height - Theme.slider.thumb.height
    readonly property real barTopMargin: Theme.slider.thumb.height / 2
    property bool isHovered: false
    readonly property bool isThumbActive: isHovered || drag.active

    implicitHeight: Theme.slider.height

    // Background (empty part)
    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: root.barTopMargin
        height: root.barHeight
        color: Theme.slider.color.inactive
    }

    // Foreground (filled part)
    Rectangle {
        id: foreground
        readonly property real thumbWidth: root.isThumbActive ? Theme.slider.thumb.width + Theme.slider.thumb.padding : 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: root.barTopMargin
        height: root.barHeight
        width:
            root.maxValue <= 0
                ? 0
                : (parent.width - thumbWidth) * root.value / root.maxValue
        color: root.color
    }

    Rectangle {
        id: thumb
        anchors.left: foreground.right
        anchors.leftMargin: foreground.width >= 1 ? Theme.slider.thumb.padding : 0
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Theme.slider.thumb.width
        color: Theme.slider.thumb.color
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
            const slide = parent.width === 0 ? 0 : point.position.x / parent.width
            root.slide(slide * root.maxValue)
        }
    }

    DragHandler {
        id: drag
        enabled: root.canSeek
        target: null
        onTranslationChanged: {
            const slide = parent.width === 0 ? 0 : Math.max(0, Math.min(parent.width, centroid.position.x)) / parent.width
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
