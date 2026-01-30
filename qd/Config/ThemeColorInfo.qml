pragma ComponentBehavior: Bound

import QtQuick

Base {
    property ThemeColorInfo _defaults

    property var primary:   _defaults?.primary
    property var secondary: _defaults?.secondary
    property var accent:    _defaults?.accent
}
