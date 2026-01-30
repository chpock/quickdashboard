pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell

PanelWindow {
    id: root

    enum Align {
        AlignRight = 0,
        AlignLeft = 1
    }

    default property alias content: content.data
    property real spacing: 2
    property int align: 0

    implicitWidth: 212

    anchors {
        right: align === 0
        left: align === 1
        top: true
        bottom: true
    }

    color: 'transparent'

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: root.spacing
    }

}
