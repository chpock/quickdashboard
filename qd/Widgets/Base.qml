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
import qs.qd as QD
import qs.qd.Config as C

Rectangle {
    id: root
    readonly property string type: {
        const objectName = root.toString()
        return objectName.slice(0, objectName.indexOf('_'))
    }
    property string _chain
    property var _dashboard

    default property alias content: content.data

    property var theme: ({})
    readonly property C.Theme _theme: C.Theme {
        _defaults: root._dashboard?._theme ?? QD.Defaults.theme
        _custom: root.theme
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.theme'
    }

    property var defaults: ({})
    readonly property C.Defaults _defaults: C.Defaults {
        _defaults: root._dashboard?._defaults ?? QD.Defaults.defaults
        _custom: root.defaults
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.defaults'
    }

    property var widget: ({})
    readonly property C.Widget _widget: C.Widget {
        _defaults: root._dashboard?._widget ?? QD.Defaults.widget
        _custom: root.widget
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.widget'
    }

    property var fragments: ({})
    property var _fragments

    border {
        color: _theme.getColor(_widget.border.color)
        width: _widget.border.width
    }

    color: _theme.getColor(_widget.background.color)

    width: parent.width
    implicitHeight: content.implicitHeight
        + _widget.padding.top + _widget.padding.bottom
        + _widget.border.width * 2

    HoverHandler {
        id: hh
    }

    readonly property bool isHovered: hh.hovered

    Column {
        id: content
        y:             root._widget.padding.left + root._widget.border.width
        spacing:       root._widget.spacing.vertical
        width:         parent.width
        anchors.left:  parent.left
        anchors.right: parent.right
        anchors.leftMargin:   root._widget.padding.left   + root._widget.border.width
        anchors.rightMargin:  root._widget.padding.right  + root._widget.border.width
        anchors.topMargin:    root._widget.padding.top    + root._widget.border.width
        anchors.bottomMargin: root._widget.padding.bottom + root._widget.border.width
    }

    // function recreateConfig() {
    //     // _config.widget.destroy()
    //     // _config.widget = configWidget.createObject(_config)
    //     // _config.theme.destroy()
    //     // _config.theme = configTheme.createObject(_config)
    //     // _config.defaults.destroy()
    //     // _config.defaults = configDefaults.createObject(_config)
    //     if (configFragments) configFragments.destroy()
    //     recreateConfigFragments()
    // }
    //
    // function recreateConfigFragments() {
    //     _config.fragments = null
    // }
    //
    // function applyConfig(target, source, path) {
    //     Object.entries(source).forEach(([key, value]) => {
    //         if (target[key] === undefined) {
    //             console.warn('Config property "' + path + key + '" does not exist on the target widget.')
    //             return
    //         }
    //         if (typeof value === 'object' && value !== null && !Array.isArray(value)) {
    //             applyConfig(target[key], value, path + key + '.')
    //         } else {
    //             try {
    //                 target[key] = value;
    //             } catch (e) {
    //                 console.error('Failed to set config property "' + path + key + '": ' + e.message);
    //             }
    //         }
    //     })
    // }
    //
    // Component.onCompleted: {
    //     // console.log("base completed!")
    //     recreateConfig()
    //     // console.log("apply config!")
    //     // if (_config.fragments) {
    //     //     applyConfig(_config.fragments, fragments, '.')
    //     // }
    //     // applyConfig(_config, config, '.')
    //     // console.log("complete - done")
    // }
}
