/*
    This file is a part of quickdashboard: https://github.com/chpock/quickdashboard

    Copyright (C) 2025-2026 Kostiantyn Kushnir <chpock@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.qd as QD
import qs.qd.Config as C

PanelWindow {
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

    enum Align {
        AlignRight = 0,
        AlignLeft = 1
    }

    default property alias content: content.data

    property real spacing: 2
    property int align: 0

    implicitWidth: 212

    anchors {
        right: align === 0
        left: align === 1
        top: true
        bottom: true
    }

    color: 'transparent'

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: root.spacing

        Component.onCompleted: {
            processChildren()
        }

        onChildrenChanged: {
            processChildren()
        }

        function processChildren() {
            for (let i = 0; i < children.length; i++) {
                const child = children[i]
                if (child.hasOwnProperty('_dashboard') && child._dashboard === undefined) {
                    child._dashboard = root
                }
            }
        }
    }

}
