pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property BarColor _defaults

    property var active:   _defaults?.active
    property var inactive: _defaults?.inactive
}
