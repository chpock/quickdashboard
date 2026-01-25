pragma ComponentBehavior: Bound

import QtQuick

Base {
    property TextTitleSeparator _defaults

    property var enabled: _defaults?.enabled
    property var color:   _defaults?.color
    property var text:    _defaults?.text
}
