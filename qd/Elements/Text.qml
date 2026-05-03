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
import qs.qd.Config as C

Item {
    id: root

    required property C.Text config
    required property C.Theme theme

    property var text
    property var args
    property var fontVariableAxes: ({})
    property var style
    property var strikeout
    readonly property C.Text _config: (config._styles_loaded && style && config.getStyle(style)) || config
    readonly property bool isHovered: hoverHandler.hovered

    readonly property real leftMargin: calcMargin(_config.padding.left)
    readonly property real rightMargin: calcMargin(_config.padding.right)
    readonly property real effectiveWidth: Math.max(0, width - leftMargin - rightMargin)
    readonly property real wordSpacing: Math.round(spaceMetrics2.boundingRect.width - spaceMetrics1.boundingRect.width)

    implicitHeight:
        textMetrics.tightBoundingRect.height +
        root._config.padding.top + root._config.padding.bottom
    implicitWidth:  textObj.implicitWidth + leftMargin + rightMargin
    clip: _config._overflow === C.Text.OverflowScroll

    function calcMargin(value) {
        if (typeof value === "string") {
            const len = value.length
            if (len >=3 && value.endsWith('ch')) {
                const numericPart = value.substring(0, len - 2)
                if (numericPart.trim() !== '') {
                    const charsCount = +numericPart
                    if (isFinite(charsCount)) {
                      return charsCount * root.wordSpacing
                    }
                }
            }
        }
        return value
    }

    // Rectangle {
    //     anchors.fill: parent
    //     color: 'blue'
    //     border.color: 'red'
    //     border.width: 1
    // }

    // Rectangle {
    //     x: textObj.x
    //     y: textObj.y
    //     height: textObj.height
    //     width: textObj.width
    //     color: 'green'
    // }

    // Rectangle {
    //     width: textObj.width
    //     height: textObj.height
    //     x: textObj.x
    //     y: textObj.y
    //     color: {
    //         if (root.debug) {
    //             console.log("dbg:", height)
    //         }
    //         return '#54d70000'
    //     }
    // }

    Rectangle {
        anchors.fill: parent
        color: root.theme.getColor(root._config.background)
    }

    Text {
        id: textObj

        property real scrollOffset: 0
        readonly property bool needsScrolling:
            root._config._overflow === C.Text.OverflowScroll && root.visible && root.effectiveWidth > 0 && root.effectiveWidth < implicitWidth

        text: {
            let text = root.text == null ? root._config.text : root.text
            if (Array.isArray(root.args)) {
                for (let i = 0; i < root.args.length; ++i) {
                    text = text.arg(root.args[i])
                }
            }
            return text
        }
        textFormat: Text.PlainText
        wrapMode: Text.NoWrap
        color: root.theme.getColor(root._config.color)
        font.pixelSize: root.theme.getFontSize(root._config.font.size)
        font.weight: root.theme.getFontWeight(root._config.font.weight)
        font.strikeout: root.strikeout ?? root._config.font.strikeout
        font.family: root.theme.getFontFamily(root._config.font.family)
        font.variableAxes: root.fontVariableAxes
        horizontalAlignment: root._config.alignment._horizontal
        verticalAlignment: root._config.alignment._vertical
        // verticalAlignment: Text.AlignVCenter
        elide: root._config._overflow === C.Text.OverflowElide ? Text.ElideRight : Text.ElideNone
        // TODO: leftMargin doesn't work with scrolled text. It is just ignored.
        // We need to place Text in a container (Item) with strict boundaries.
        x: needsScrolling ? root.leftMargin - scrollOffset : root.leftMargin
        width: root.effectiveWidth

        anchors.top: parent.top
        anchors.topMargin: root._config.padding.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root._config.padding.bottom

        onTextChanged: {
            scrollOffset = 0
            if (needsScrolling) animation.restart()
        }

        SequentialAnimation {
            id: animation
            running: textObj.needsScrolling
            loops: Animation.Infinite

            readonly property real duration:
                textObj.implicitWidth === 0
                    ? 1000
                    : Math.max(1000, 1000 * root._config.scroll.duration * (textObj.implicitWidth - root.effectiveWidth) / root.effectiveWidth)

            PauseAnimation {
                duration: root._config.scroll.pauseStart
            }

            NumberAnimation {
                target: textObj
                property: 'scrollOffset'
                from: 0
                to: textObj.implicitWidth - root.effectiveWidth
                duration: animation.duration
                easing.type: Easing.Linear
            }

            PauseAnimation {
                duration: root._config.scroll.pauseEnd
            }

            NumberAnimation {
                target: textObj
                property: 'scrollOffset'
                to: 0
                duration: animation.duration
                easing.type: Easing.Linear
            }
        }

    }

    TextMetrics {
        id: textMetrics
        font: textObj.font
        text:
            root._config._heightMode === C.Text.HeightContent
                ? textObj.text
                : root._config._heightMode === C.Text.HeightCapitals
                    ? 'H%0'
                    : 'H%0bdfhklgjpqy'
    }

    TextMetrics {
        id: spaceMetrics1
        font.pixelSize: textObj.font.pixelSize
        font.weight: textObj.font.weight
        font.family:
            root._config.word_spacing_font_family && root._config.word_spacing_font_family !== ''
                ? root.theme.getFontFamily(root._config.word_spacing_font_family)
                : textObj.font.family
        font.variableAxes: textObj.font.variableAxes
        text: '++'
    }

    TextMetrics {
        id: spaceMetrics2
        font.pixelSize: textObj.font.pixelSize
        font.weight: textObj.font.weight
        font.family:
            root._config.word_spacing_font_family && root._config.word_spacing_font_family !== ''
                ? root.theme.getFontFamily(root._config.word_spacing_font_family)
                : textObj.font.family
        font.variableAxes: textObj.font.variableAxes
        text: '+ +'
    }

    FontMetrics {
        id: fontMetrics
        font: textObj.font
    }

    HoverHandler {
        id: hoverHandler
        enabled: root.config.hover.enabled
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
    }

}
