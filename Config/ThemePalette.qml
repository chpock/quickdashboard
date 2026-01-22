pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    id: root

    property color cyan_bright
    property color cyan
    property color green_bright
    property color green
    property color blue_bright
    property color blue
    property color megenta_bright
    property color megenta
    property color yellow_bright
    property color yellow
    property color orange_bright
    property color orange
    property color red_bright
    property color red
    property color white_bright
    property color white
    property color gray_bright
    property color gray

    property var names

    function getByIndex(value) {
        const idx = (value >= names.length || value < 0) ? 0 : value
        const name = names[idx]
        return root[name]
    }
}
