pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

Item {
    id: root

    required property C.Bar config
    required property C.Theme theme

    property real maxValue: 100.0
    property real value: 0

    readonly property real effectiveWidth: Math.max(0, width - root.config.padding.left - root.config.padding.right)

    implicitHeight: config.height + config.padding.top + config.padding.bottom

    // Background (empty part)
    Rectangle {
        id: background

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.right: parent.right
        anchors.rightMargin: root.config.padding.right
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        height: root.config.height
        color: root.theme.getColor(root.config.color.inactive)
    }

    // Foreground (filled part)
    Rectangle {
        id: foreground

        anchors.left: parent.left
        anchors.leftMargin: root.config.padding.left
        anchors.top: parent.top
        anchors.topMargin: root.config.padding.top
        height: root.config.height
        width:
            root.maxValue <= 0
                ? 0
                : root.effectiveWidth * root.value / root.maxValue
        color: root.theme.getColor(root.config.color.active)
    }
}
