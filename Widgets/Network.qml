pragma ComponentBehavior: Bound

import QtQuick
import qs
import qs.Elements as E
import qs.Providers as Provider

Base {
    id: root

    readonly property var theme: QtObject {
        readonly property var ifaceList: QtObject {
            readonly property var details: QtObject {
                property string preset: "normal"
                readonly property var color: QtObject {
                    property color normal: Theme.text.color.normal
                    property color error: Theme.text.color.error
                }
            }
            readonly property var signal: QtObject {
                property string preset: "normal"
                property var levels: ({
                    'good':     [75, 100],
                    'warning':  [20, 74 ],
                    'critical': [ 0, 19 ],
                })
            }
        }
        readonly property var latency: QtObject {
            readonly property var title: QtObject {
                readonly property var padding: QtObject {
                    property int bottom: 4
                }
            }
            readonly property var marks: QtObject {
                readonly property int width: 8
                readonly property var padding: QtObject {
                    property int top: 3
                    property int bottom: 1
                    property int left: 0
                    property int right: 0
                }
                readonly property int spacing: 5
                readonly property int border: 1
            }
            readonly property var thresholds: QtObject {
                property real good: 40
            }
            readonly property var color: QtObject {
                property color good: Theme.color.ok
                property color warning: Theme.color.warning
                property color error: Theme.color.error
            }
        }
        readonly property var rate: QtObject {
            readonly property var preset: QtObject {
                property var label: "normal"
                property var value: "details"
            }
            readonly property var download: QtObject {
                property color color: Theme.palette.belizehole
                property string label: "D:"
            }
            readonly property var upload: QtObject {
                property color color: Theme.palette.greensea
                property string label: "U:"
            }
            readonly property var graph: QtObject {
                property int maxValue: 1024 * 5
            }
            property int spacing: 2
        }
    }

    Connections {
        target: Provider.Network
        function onUpdateNetworkRate(data) {
            rates.children[0].children[2].pushValue(data.rxrate)
            rates.children[1].children[2].pushValue(data.txrate)
        }
    }

    Column {
        id: wireless

        anchors.left: parent.left
        anchors.right: parent.right

        property int ifaceWidth: 0

        Repeater {
            model: Provider.WirelessDevices.ifaceModel

            Item {
                id: ifaceRow
                required property var modelData

                implicitHeight: Math.max(ifaceObj.implicitHeight)
                anchors.left: parent.left
                anchors.right: parent.right

                E.TextTitle {
                    id: ifaceObj
                    text: ifaceRow.modelData.iface
                    anchors.left: parent.left
                    onImplicitWidthChanged: {
                        if (implicitWidth > wireless.ifaceWidth)
                            wireless.ifaceWidth = implicitWidth
                    }
                }

                E.Text {
                    id: ssidObj
                    text: ifaceRow.modelData.ssid
                    preset: root.theme.ifaceList.details.preset
                    anchors.left: ifaceObj.right
                    anchors.right: parent.right
                    color:
                        parent.modelData.isConnected
                            ? root.theme.ifaceList.details.color.normal
                            : root.theme.ifaceList.details.color.error
                    overflow: E.Text.OverflowElide
                    horizontalAlignment: Text.AlignLeft
                }

                E.TextPercent {
                    id: signal
                    value: ifaceRow.modelData.signal
                    levels: root.theme.ifaceList.signal.levels
                    preset: root.theme.ifaceList.signal.preset
                    anchors.right: parent.right
                    visible: ifaceRow.modelData.isConnected
                }
            }
        }
    }

    Item {
        id: latency

        property string hoveredMarkName: ''
        property real hoveredMarkTime: Infinity

        function timeToColor(value) {
            if (!Number.isFinite(value)) return root.theme.latency.color.error
            return value <= root.theme.latency.thresholds.good
                ? root.theme.latency.color.good
                : root.theme.latency.color.warning
        }

        anchors.left: parent.left
        anchors.right: parent.right
        implicitHeight:
        Math.max(latencyTitle.implicitHeight, latencyValue.implicitHeight) +
            root.theme.latency.title.padding.bottom +
            latencyDetails.implicitHeight

        E.TextTitle {
            id: latencyTitle
            text: 'Latency'
            anchors.left: parent.left
        }

        E.Text {
            id: latencyValue
            readonly property real time: latencyDotsHover.hovered ? latency.hoveredMarkTime : Provider.Network.latency.time
            text: Number.isFinite(time) ? Math.round(time) + ' ms' : 'ERR'
            color: latency.timeToColor(time)
            anchors.right: parent.right
            // color: modelData.isConnected ? root.theme.ifaceList.details.color.normal : root.theme.ifaceList.details.color.error
        }

        E.Text {
            id: latencyDetails
            text: latencyDotsHover.hovered ? latency.hoveredMarkName : Provider.Network.latency.name
            anchors.top: latencyTitle.bottom
            anchors.topMargin: root.theme.latency.title.padding.bottom
            anchors.left: parent.left
            anchors.right: latencyDots.left
            preset: 'details'
            overflow: E.Text.OverflowElide
        }

        Row {
            id: latencyDots

            anchors.top: latencyDetails.top
            anchors.bottom: latencyDetails.bottom
            anchors.right: parent.right
            spacing: root.theme.latency.marks.spacing

            Repeater {
                model: Provider.Network.latencyHostsModel

                Item {
                    id: item

                    required property var modelData

                    readonly property bool isActive:
                        hover.hovered || (!latencyDotsHover.hovered && modelData.host === Provider.Network.latency.host)
                    readonly property color color: latency.timeToColor(modelData.time)

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    implicitWidth: mark.implicitWidth + root.theme.latency.marks.padding.left + root.theme.latency.marks.padding.right

                    Rectangle {
                        id: mark
                        implicitWidth: root.theme.latency.marks.width
                        anchors.top: parent.top
                        anchors.topMargin: root.theme.latency.marks.padding.top
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: root.theme.latency.marks.padding.bottom
                        anchors.right: parent.right
                        anchors.rightMargin: root.theme.latency.marks.padding.right

                        color: parent.isActive ? parent.color : 'transparent'
                        border.width: root.theme.latency.marks.border
                        border.color: parent.color
                    }

                    HoverHandler {
                        id: hover
                        onHoveredChanged: {
                            if (hovered) {
                                latency.hoveredMarkName = Qt.binding(() => item.modelData.name)
                                latency.hoveredMarkTime = Qt.binding(() => item.modelData.time)
                            }
                        }
                    }
                }

            }

            HoverHandler {
                id: latencyDotsHover
            }
        }

    }

    Row {
        id: rates

        width: parent.width
        spacing: Theme.base.spacing.vertical

        Repeater {
            model: ['download', 'upload']

            Item {
                id: rateItem

                required property var modelData

                implicitHeight: Math.max(label.implicitHeight, rate.implicitHeight) + root.theme.rate.spacing + graph.implicitHeight
                implicitWidth: (parent.width - rates.spacing) / 2

                E.Text {
                    id: label
                    text: root.theme.rate[rateItem.modelData].label
                    color: root.theme.rate[rateItem.modelData].color
                    anchors.left: parent.left
                    anchors.top: parent.top
                    preset: root.theme.rate.preset.label
                }

                E.TextBytes {
                    id: rate
                    anchors.right: parent.right
                    anchors.bottom: label.bottom
                    preset: root.theme.rate.preset.value
                    value: Provider.Network.rate[rateItem.modelData]
                    isRate: true
                }

                E.GraphTimeseries {
                    id: graph
                    color: root.theme.rate[rateItem.modelData].color
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    maxValueAuto: true
                    maxValue: root.theme.rate.graph.maxValue
                }

            }

        }

    }

}
