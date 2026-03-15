pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.qd.Config as C
import qs.qd as QD

Scope {
    id: root

    readonly property string type: {
        const objectName = root.toString()
        return objectName.slice(0, objectName.indexOf('_'))
    }
    property string _chain

    property var theme: ({})
    readonly property C.Theme _theme: C.Theme {
        _defaults: QD.Defaults.theme
        _custom: root.theme
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.theme'
    }

    property var defaults: ({})
    readonly property C.Defaults _defaults: C.Defaults {
        _defaults: QD.Defaults.defaults
        _custom: root.defaults
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.defaults'
    }

    property var widget: ({})
    readonly property C.Widget _widget: C.Widget {
        _defaults: QD.Defaults.widget
        _custom: root.widget
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.widget'
    }

    default property list<QtObject> children

    Component.onCompleted: {
        processChildren()
    }

    onChildrenChanged: {
        processChildren()
    }

    function processChildren() {
        for (const child of children) {
            if (child.hasOwnProperty('_quickdashboard') && child._quickdashboard === undefined) {
                child._quickdashboard = root
            }
        }
    }

}
