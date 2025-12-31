pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    enum Fill {
        FillNone = 0,
        FillHorizontal = 1,
        FillVertical = 2
    }

    property int fill: 2

    Layout.fillHeight: fill === 2
    Layout.fillWidth: fill === 1
}
