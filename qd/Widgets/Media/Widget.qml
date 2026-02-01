pragma ComponentBehavior: Bound

import QtQuick
import qs.qd.Elements as E
import qs.qd.Widgets as Widget
import qs.qd.Providers as Provider

Widget.Base {
    id: root

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
    }

    component AlbumArt: Rectangle {
        id: album_art

        readonly property var config: root._fragments.album_art
        property bool isUnknown: !Provider.Mpris.hasTrackArt || isImageEmpty
        property bool isImageEmpty: true

        implicitWidth: config.size.width
        implicitHeight: config.size.height
        color: 'transparent'
        border.width: config.border.width
        border.color: root._theme.getColor(config.border.color)

        E.Icon {
            theme: root._theme
            config: album_art.config.no_art

            anchors.fill: parent
            visible: parent.isUnknown
        }

        Image {
            id: image

            anchors.fill: parent
            asynchronous: true
            // Don't cache to not waste RAM
            cache: false
            fillMode: Image.PreserveAspectCrop
            retainWhileLoading: true
            source: Provider.Mpris.trackArtUrl
            visible: !parent.isUnknown
            onStatusChanged: {
                if (image.status === Image.Ready) {
                    parent.isImageEmpty = false
                } else if (image.status === Image.Null || image.status === Image.Error) {
                    parent.isImageEmpty = true
                }
            }
        }

        TapHandler {
            enabled: Provider.Mpris.hasRaise
            gesturePolicy: TapHandler.WithinBounds
            onTapped: {
                Provider.Mpris.raise()
            }
        }

        HoverHandler {
            enabled: Provider.Mpris.hasRaise
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.PointingHandCursor
        }
    }

    component Control: Item {
        id: control

        readonly property var config: root._fragments.player.control

        readonly property int buttonCount:
            (prev.visible ? 1 : 0) +
            (toggle.visible ? 1 : 0) +
            (next.visible ? 1 : 0)

        implicitHeight:
            row.implicitHeight +
            config.padding.top + config.padding.bottom
        implicitWidth:
            (prev.visible ? prev.implicitWidth : 0) +
            (toggle.visible ? toggle.implicitWidth : 0) +
            (next.visible ? next.implicitWidth : 0) +
            (buttonCount > 1 ? (buttonCount - 1) * row.spacing : 0) +
            config.padding.left + config.padding.right

        Row {
            id: row

            anchors.top: parent.top
            anchors.topMargin: control.config.padding.top
            anchors.left: parent.left
            anchors.leftMargin: control.config.padding.left
            anchors.right: parent.right
            anchors.rightMargin: control.config.padding.right
            spacing: control.config.spacing.horizontal

            E.Icon {
                id: prev
                theme: root._theme
                config: control.config.button

                style: 'previous'
                visible: Provider.Mpris.hasPrev
                onClicked: Provider.Mpris.prev()
            }

            E.Icon {
                id: toggle
                theme: root._theme
                config: control.config.button

                style:
                    'toggle/' +
                    (
                        Provider.Mpris.isPaused
                        ? 'resume'
                        : Provider.Mpris.isStopped
                            ? 'play'
                            : Provider.Mpris.hasPause
                                ? 'pause'
                                : 'stop'
                    )
                visible: Provider.Mpris.hasToggle
                onClicked: Provider.Mpris.toggle()
            }

            E.Icon {
                id: next
                theme: root._theme
                config: control.config.button

                style: 'next'
                visible: Provider.Mpris.hasNext
                onClicked: Provider.Mpris.next()
            }
        }
    }

    component Player: Item {
        id: player

        readonly property var config: root._fragments.player

        implicitHeight:
            status_box.implicitHeight +
            slider.implicitHeight +
            track.implicitHeight +
            artist.implicitHeight

        Item {
            id: status_box

            implicitHeight:
                Math.max(
                    status.implicitHeight,
                    playing_time.implicitHeight,
                    control.implicitHeight,
                )
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            readonly property bool visibleTime:
                !statusBoxHovered.hovered && Provider.Mpris.hasLength && Provider.Mpris.hasPosition
            readonly property bool visibleControl:
                !visibleTime && (Provider.Mpris.hasPrev || Provider.Mpris.hasToggle || Provider.Mpris.hasNext)

            E.Text {
                id: status
                theme: root._theme
                config: player.config.status

                style: Provider.Mpris.status
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.right:
                    parent.visibleTime
                        ? playing_time.left
                        : parent.visibleControl
                            ? control.left
                            : parent.right
                anchors.rightMargin: (parent.visibleTime || parent.visibleControl) ? wordSpacing : 0

                TapHandler {
                    enabled: Provider.Mpris.hasPlayer
                    gesturePolicy: TapHandler.WithinBounds
                    onTapped: {
                        Provider.Mpris.toggle()
                    }
                }
                HoverHandler {
                    enabled: Provider.Mpris.hasPlayer
                    acceptedButtons: Qt.NoButton
                    cursorShape: Qt.PointingHandCursor
                }
            }

            E.Text {
                id: playing_time
                theme: root._theme
                config: player.config.time

                text: {
                    const time = Math.max(0, Provider.Mpris.length - Provider.Mpris.position)
                    const hours = Math.floor(time / 3600)
                    const mins = Math.floor((time % 3600) / 60)
                    const secs = time % 60
                    const hoursStr = hours !== 0 ? (((hours < 10 ? '0' : '') + hours) + ':') : ''
                    const minsStr = (mins < 10 ? '0' : '') + mins + ':'
                    const secsStr = (secs < 10 ? '0' : '') + secs
                    return hoursStr + minsStr + secsStr
                }
                anchors.right: parent.right
                anchors.top: parent.top
                visible: parent.visibleTime
            }

            Control {
                id: control

                visible: parent.visibleControl
                anchors.right: parent.right
            }

            HoverHandler {
                id: statusBoxHovered
            }
        }

        E.Slider {
            id: slider
            theme: root._theme
            config: player.config.slider

            value: Provider.Mpris.position
            maxValue: Provider.Mpris.length
            anchors.top: status_box.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            canSeek: Provider.Mpris.hasSeek
            onSlide: offset => {
                Provider.Mpris.activePlayer.position = offset
            }
        }

        E.Text {
            id: track
            theme: root._theme
            config: player.config.track

            text: Provider.Mpris.track
            anchors.top: slider.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: Provider.Mpris.hasPlayer
        }

        E.Text {
            id: artist
            theme: root._theme
            config: player.config.artist

            text: Provider.Mpris.artist
            anchors.top: track.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            visible: Provider.Mpris.hasPlayer
        }

    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight:
            Math.max(
                album_art.implicitHeight + album_art.config.padding._vertical,
                player.implicitHeight,
            )

        AlbumArt {
            id: album_art

            anchors.left: parent.left
            anchors.leftMargin: config.padding.left
            anchors.top: parent.top
            anchors.topMargin: config.padding.top
        }

        Player {
            id: player

            anchors.left: album_art.right
            anchors.leftMargin: album_art.config.padding.right
            anchors.right: parent.right
        }

    }

}
