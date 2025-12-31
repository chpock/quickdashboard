pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Services as Service

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

    // See comments in QuickshellUtils.qml about this hack

    property var previous: ({
        width: -1,
        height: -1
    })

    function changeDimentions(what, val) {
        if (previous[what] != -1) {
            Service.QuickshellUtils.registerDelta(what, screen.name, val - previous[what])
        }
        previous[what] = val
    }

    onHeightChanged: changeDimentions('height', height)
    onWidthChanged: changeDimentions('width', width)

}
