pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Providers as Provider
import qs.Widgets as Widget

Widget.Base {
    id: root
    type: 'audio_volume'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
    }

    component VolumeItem: Item {
        id: item

        required property var modelData

        readonly property var config: root._fragments
        readonly property var device: modelData.device
        readonly property var audio: device ? device.audio : null
        readonly property bool isAvailable: audio !== null
        readonly property real volume: isAvailable ? audio.volume : 0
        readonly property bool isMuted: isAvailable && (audio.muted || volume === 0)
        readonly property string description: isAvailable ? device.description : 'Unavailable'
        readonly property bool hasIndicator: isAvailable && (isHeadset || isHdmi)
        readonly property bool isHeadset: isAvailable && (device.name.includes('bluez') || device.name.includes('hdmi'))
        readonly property bool isHdmi: isAvailable && device.name.includes('hdmi')

        implicitHeight:
            Math.max(icon.implicitHeight, deviceObj.implicitHeight, volumeObj.implicitHeight) +
            slider.implicitHeight

        function setVolume(newVolume) {
            device.audio.volume = newVolume
            if (newVolume > 0.0001 && device.audio.muted) {
                device.audio.muted = false
            } else if (newVolume <= 0.0001 && !device.audio.muted) {
                device.audio.muted = true
            }
        }

        E.Icon {
            id: icon
            theme: root._theme
            config: item.config.icon

            icon:
                !item.isAvailable || item.isMuted
                    ? item.modelData.icon.muted
                    : item.modelData.icon.normal
            style:
                !item.isAvailable
                    ? 'unavailable'
                    : item.isMuted
                        ? 'muted'
                        : undefined
            anchors.left: parent.left
        }

        E.Icon {
            id: indicator
            theme: root._theme
            config: item.config.indicator

            icon:
                item.isHeadset
                    ? item.modelData.icon.headset
                    : item.isHdmi
                        ? item.modelData.icon.hdmi
                        : ''
            anchors.left: icon.right
            visible: parent.hasIndicator
        }

        E.Text {
            id: deviceObj
            theme: root._theme
            config: item.config.device

            text: parent.description
            style:
                !item.isAvailable
                    ? 'unavailable'
                    : itemHoverHandler.hovered
                        ? 'hover'
                        : undefined
            anchors.right: volumeObj.left
            anchors.left: indicator.visible ? indicator.right : icon.right
            anchors.top: parent.top
            anchors.bottom: icon.bottom
        }

        E.TextPercent {
            id: volumeObj
            theme: root._theme
            config: item.config.percent

            valueCurrent: parent.volume
            valueMax: 1.0
            anchors.right: parent.right
        }

        E.Slider {
            id: slider
            theme: root._theme
            config: item.config.slider

            value: parent.volume
            maxValue: 1.0
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            onSlide: offset => {
                item.setVolume(offset)
            }
        }

        HoverHandler {
            id: itemHoverHandler
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.PointingHandCursor
        }

        WheelHandler {
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: event => slider.wheelHandler(event)
        }

        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: {
                parent.device.audio.muted = !parent.device.audio.muted
                if (!parent.device.audio.muted && parent.volume === 0) {
                    parent.device.audio.volume = 0.01
                }
            }
        }
    }

    Repeater {
        model: [
            {
                name: "output",
                device: Provider.AudioDevices.sink,
                icon: {
                    normal: 'volume_up',
                    muted: 'volume_off',
                    headset: 'headphones',
                    hdmi: 'connected_tv',
                },
            },
            {
                name: "input",
                device: Provider.AudioDevices.source,
                icon: {
                    normal: 'mic',
                    muted: 'mic_off',
                    headset: 'headset_mic',
                    hdmi: 'connected_tv',
                }
            },
        ]

        VolumeItem {
            anchors.left: parent?.left
            anchors.right: parent?.right
        }
    }

}
