pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property Spacing _defaults

    property var horizontal: _defaults?.horizontal
    property var vertical:   _defaults?.vertical
}
