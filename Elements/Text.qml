pragma ComponentBehavior: Bound

import QtQuick
import qs

Item {
    id: root

    enum HeightMode {
        Capitals = 0,
        Normal = 1,
        Content = 2
    }

    enum Overflow {
        OverflowNone = 0,
        OverflowElide = 1,
        OverflowAnimate = 2
    }

    property string preset: ""

    readonly property int wordSpacing: Math.round(spaceMetrics2.boundingRect.width - spaceMetrics1.boundingRect.width)

    property alias text: textObj.text
    property var color: undefined
    property int fontWeight: -1
    property int fontSize: -1
    property bool fontStrikeout: false
    property var fontFamily: Theme.normalFont.name
    property var fontFamilySpacing: textObj.font.family
    property var fontVariableAxes: ({})
    property alias horizontalAlignment: textObj.horizontalAlignment
    property alias fontSizeMode: textObj.fontSizeMode
    property var verticalAlignment: undefined
    property int heightMode: 1
    property int overflow: 0

    property int animScrollDuration: 7
    property int animPauseStartDuration: 6000
    property int animPauseEndDuration: 2000

    implicitHeight: textMetrics.tightBoundingRect.height
    implicitWidth:  textObj.implicitWidth
    clip: overflow === 2

    // Rectangle {
    //     anchors.fill: parent
    //     color: 'blue'
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

    Text {
        id: textObj

        property real scrollOffset: 0
        readonly property bool needsScrolling:
            root.overflow === 2 && root.visible && root.width > 0 && root.width < implicitWidth

        height: textMetrics.tightBoundingRect.height
        textFormat: Text.PlainText
        wrapMode: Text.NoWrap
        color:
            root.color !== undefined
                ? root.color
                : Theme.preset[root.preset !== '' ? root.preset : 'normal'].color
        font.pixelSize:
            root.fontSize !== -1
                ? root.fontSize
                : Theme.preset[root.preset !== '' ? root.preset : 'normal'].fontSize
        font.weight:
            root.fontWeight !== -1
                ? root.fontWeight
                : Theme.preset[root.preset !== '' ? root.preset : 'normal'].fontWeight
        font.strikeout: root.fontStrikeout
        font.family: root.fontFamily
        font.variableAxes: root.fontVariableAxes
        verticalAlignment: root.verticalAlignment === undefined ? Text.AlignVCenter : root.verticalAlignment
        elide: root.overflow === 1 ? Text.ElideRight : Text.ElideNone
        x: needsScrolling ? -scrollOffset : 0
        width: root.overflow === 0 && implicitWidth > parent.width ? undefined : parent.width
        anchors.top: parent.top
        anchors.bottom: parent.bottom

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
                    : Math.max(1000, 1000 * root.animScrollDuration * (textObj.implicitWidth - root.width) / root.width)

            PauseAnimation {
                duration: root.animPauseStartDuration
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
                duration: root.animPauseEndDuration
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
            root.heightMode === 2
                ? textObj.text
                : root.heightMode === 0
                    ? 'H%0'
                    : 'H%0bdfhklgjpqy'
    }

    TextMetrics {
        id: spaceMetrics1
        font: root.fontFamilySpacing
        text: 'AA'
    }

    TextMetrics {
        id: spaceMetrics2
        font: root.fontFamilySpacing
        text: 'A A'
    }

    FontMetrics {
        id: fontMetrics
        font: textObj.font
    }

}
