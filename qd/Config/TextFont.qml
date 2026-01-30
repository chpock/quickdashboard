pragma ComponentBehavior: Bound

import QtQuick

Base {
    property TextFont _defaults

    property var size:      _defaults?.size
    property var weight:    _defaults?.weight
    property var family:    _defaults?.family
    property var strikeout: _defaults?.strikeout
}
