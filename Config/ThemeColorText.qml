pragma ComponentBehavior: Bound

import QtQuick

Base {
    property ThemeColorText _defaults

    property var primary:    _defaults?.primary
    property var secondary:  _defaults?.secondary
    property var title:      _defaults?.title
    property var hightlight: _defaults?.hightlight
}
