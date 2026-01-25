pragma ComponentBehavior: Bound

import QtQuick

Base {
    property ThemeColorSeverity _defaults

    property var ignore:   _defaults?.ignore
    property var good:     _defaults?.good
    property var warning:  _defaults?.warning
    property var critical: _defaults?.critical
}
