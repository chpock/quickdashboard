pragma ComponentBehavior: Bound

import QtQuick

Base {
    property BarColor _defaults

    property var active:   _defaults?.active
    property var inactive: _defaults?.inactive
}
