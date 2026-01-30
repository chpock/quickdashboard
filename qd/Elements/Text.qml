pragma ComponentBehavior: Bound

import QtQuick
// import qs
import qs.qd.Config as C

Item {
    id: root

    required property C.Text config
    required property C.Theme theme

    property var text
    property var fontVariableAxes: ({})
    property var style
    property var strikeout
    readonly property C.Text _config: (config._styles_loaded && style && config.getStyle(style)) || config
    readonly property bool isHovered: hoverHandler.hovered

    readonly property real leftMargin: calcMargin(_config.padding.left)
    readonly property real rightMargin: calcMargin(_config.padding.right)
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
            root._config._overflow === C.Text.OverflowScroll && root.visible && root.width > 0 && root.width < implicitWidth

        text: root.text == null ? root._config.text : root.text
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
        x: needsScrolling ? -scrollOffset : 0
        // width:
        //     root._config._overflow === C.Text.OverflowNone && implicitWidth > parent.width
        //         ? undefined
        //         : parent.width

        // anchors.fill: parent
        // anchors.topMargin: root._config.padding.top
        // anchors.bottomMargin: root._config.padding.bottom
        // anchors.leftMargin: root.leftMargin
        // anchors.rightMargin: root.rightMargin

        anchors.top: parent.top
        anchors.topMargin: root._config.padding.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: root._config.padding.bottom

        // TODO: left/right paddings will not work for C.Text.OverflowScroll
        // I need to figure out how to make them work.

        anchors.left:
            root._config._overflow === C.Text.OverflowScroll
                ? undefined
                : parent.left
        anchors.leftMargin:
            root._config._overflow === C.Text.OverflowScroll
                ? undefined
                : root.leftMargin
        anchors.right:
            root._config._overflow === C.Text.OverflowScroll
                ? undefined
                : parent.right
        anchors.rightMargin:
            root._config._overflow === C.Text.OverflowScroll
                ? undefined
                : root.rightMargin

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
                    : Math.max(1000, 1000 * root._config.scroll.duration * (textObj.implicitWidth - root.width) / root.width)

            PauseAnimation {
                duration: root._config.scroll.pauseStart
            }

            NumberAnimation {
                target: textObj
                property: 'scrollOffset'
                from: 0
                to: textObj.implicitWidth - root.width
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
