pragma ComponentBehavior: Bound

import QtQuick
import qs.Config as C

QtObject {
    id: root

    property TextTitle _defaults

    readonly property C.Text text: C.Text {
        _defaults: root._defaults?.text ?? null
    }
    readonly property TextTitleSeparator separator: TextTitleSeparator {
        _defaults: root._defaults?.separator ?? null
    }
}
