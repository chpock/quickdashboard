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
import qs.qd.Elements as E
import qs.qd.Providers as Provider
import qs.qd.Widgets as Widget

Widget.Base {
    id: root

    readonly property var providerAudioDevices: Provider.AudioDevices.instance

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
        _custom: root.fragments
        _chain: (root._chain ? root._chain + '.' : '') + root.type + '.fragments'
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
        readonly property bool isHeadset: isAvailable && (device.name.includes('bluez') || device.name.includes('bluetooth') || device.name.includes('usb'))
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

            style:
                item.modelData.name +
                (
                    !item.isAvailable
                        ? '/unavailable'
                        : item.isMuted
                            ? '/muted'
                            : ''
                )
            anchors.left: parent.left
        }

        E.Icon {
            id: indicator
            theme: root._theme
            config: item.config.indicator

            style:
                item.modelData.name +
                (
                    item.isHeadset
                        ? '/headset'
                        : item.isHdmi
                            ? '/hdmi'
                            : ''
                )
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
                device: root.providerAudioDevices.sink,
            },
            {
                name: "input",
                device: root.providerAudioDevices.source,
            },
        ]

        VolumeItem {
            anchors.left: parent?.left
            anchors.right: parent?.right
        }
    }

}
