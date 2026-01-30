pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

Base {
    id: root

    property TextBytes _defaults

    readonly property C.Text text: C.Text {
        _defaults: root._defaults?.text ?? null
    }
    property var precision: _defaults?.precision
    property var prefix:    _defaults?.prefix
}
