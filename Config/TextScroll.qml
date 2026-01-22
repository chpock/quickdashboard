pragma ComponentBehavior: Bound

import QtQuick

QtObject {
    property TextScroll _defaults

    property var duration:   _defaults?.duration
    property var pauseStart: _defaults?.pauseStart
    property var pauseEnd:   _defaults?.pauseEnd
}
