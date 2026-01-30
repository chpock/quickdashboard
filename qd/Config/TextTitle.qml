pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Config as C

Base {
    id: root

    property TextTitle _defaults

    readonly property C.Text text: C.Text {
        _defaults: root._defaults?.text ?? null
    }
    readonly property TextTitleSeparator separator: TextTitleSeparator {
        _defaults: root._defaults?.separator ?? null
    }
}
