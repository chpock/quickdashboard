pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Widgets as Widget
import qs.Providers as Provider

Widget.Base {
    id: root
    type: 'network'
    hierarchy: ['base', type]

    _fragments: Fragments {
        _defaults: Defaults {
            widget: root
        }
    }

    Connections {
        target: Provider.Network
        function onUpdateNetworkRate(data) {
            rates.children[0].children[2].pushValue(data.rxrate)
            rates.children[1].children[2].pushValue(data.txrate)
        }
    }

    property real wirelessIfaceWidth: 0

    component WirelessIface: Item {
        id: wireless_iface

        required property var modelData
        readonly property var config: root._fragments.wireless_iface

        implicitHeight: Math.max(
            iface.implicitHeight,
            ssid.implicitHeight,
            signal.implicitHeight,
        )

        E.TextTitle {
            id: iface
            theme: root._theme
            config: wireless_iface.config.iface

            text: parent.modelData.iface
            anchors.left: parent.left
            onImplicitWidthChanged: {
                if (implicitWidth > root.wirelessIfaceWidth)
                    root.wirelessIfaceWidth = implicitWidth
            }
        }

        E.Text {
            id: ssid
            theme: root._theme
            config: wireless_iface.config.ssid

            text: parent.modelData.ssid
            anchors.left: iface.right
            anchors.right: parent.modelData.isConnected ? signal.right : parent.right
            style: !parent.modelData.isConnected ? 'error' : undefined
        }

        E.TextPercent {
            id: signal
            theme: root._theme
            config: wireless_iface.config.signal

            value: parent.modelData.signal
            anchors.right: parent.right
            visible: parent.modelData.isConnected
        }
    }

    Repeater {
        model: Provider.WirelessDevices.ifaceModel

        WirelessIface {
            anchors.left: parent.left
            anchors.right: parent.right
        }
    }

    component Latency: Item {
        id: latency

        readonly property var config: root._fragments.latency

        property string hoveredMarkName: ''
        property real hoveredMarkTime: Infinity

        implicitHeight:
            Math.max(title.implicitHeight, value.implicitHeight) +
                details.implicitHeight

        E.TextTitle {
            id: title
            theme: root._theme
            config: latency.config.title

            text: 'Latency'
            anchors.left: parent.left
        }

        E.TextSeverity {
            id: value
            theme: root._theme
            config: latency.config.value

            readonly property real time:
                marksHoverHandler.hovered
                    ? latency.hoveredMarkTime
                    : Provider.Network.latency.time

            text: Number.isFinite(time) ? Math.round(time) + ' ms' : 'ERR'
            value: time

            anchors.right: parent.right
        }

        E.Text {
            id: details
            theme: root._theme
            config: latency.config.details

            text:
                marksHoverHandler.hovered
                    ? latency.hoveredMarkName
                    : Provider.Network.latency.name
            anchors.top: title.bottom
            anchors.left: parent.left
            anchors.right: marks.left
            anchors.rightMargin: latency.config.details.padding.left
        }

        Row {
            id: marks

            anchors.top: details.top
            anchors.topMargin: latency.config.details.padding.top + latency.config.marks.padding.top
            anchors.bottom: details.bottom
            anchors.bottomMargin: latency.config.details.padding.bottom + latency.config.marks.padding.bottom
            anchors.right: parent.right
            anchors.rightMargin: latency.config.marks.padding.right
            spacing: latency.config.marks.spacing.horizontal

            Repeater {
                model: Provider.Network.latencyHostsModel

                Item {
                    id: mark

                    required property var modelData

                    readonly property bool isActive:
                        hoverHandler.hovered || (!marksHoverHandler.hovered && modelData.host === Provider.Network.latency.host)
                    readonly property color color:
                        latency.config.value.thresholds.getColor(modelData.time, root._theme)

                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    implicitWidth: rect.implicitWidth

                    Rectangle {
                        id: rect
                        implicitWidth: latency.config.marks.width
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        color: parent.isActive ? parent.color : 'transparent'
                        border.width: latency.config.marks.border.width
                        border.color: parent.color
                    }

                    HoverHandler {
                        id: hoverHandler
                        onHoveredChanged: {
                            if (hovered) {
                                latency.hoveredMarkName = Qt.binding(() => mark.modelData.name)
                                latency.hoveredMarkTime = Qt.binding(() => mark.modelData.time)
                            }
                        }
                    }
                }

            }

            HoverHandler {
                id: marksHoverHandler
            }
        }

    }

    Latency {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    component DNS: Item {
        id: dns

        readonly property var config: root._fragments.dns

        readonly property bool isOk: Number.isFinite(Provider.Network.dnsCheckTime)

        implicitHeight: Math.max(title.implicitHeight, latency.implicitHeight, status.implicitHeight)

        E.TextTitle {
            id: title
            theme: root._theme
            config: dns.config.title

            text: 'DNS'
            anchors.left: parent.left
        }

        E.Text {
            id: latency
            theme: root._theme
            config: dns.config.latency

            text: dns.isOk ? Provider.Network.dnsCheckTime + ' ms' : ''
            anchors.left: title.right
            anchors.bottom: title.bottom
        }

        E.TextSeverity {
            id: status
            theme: root._theme
            config: dns.config.status

            text: dns.isOk ? 'Ok' : 'ERR'
            value: Provider.Network.dnsCheckTime
            anchors.right: parent.right
        }
    }

    DNS {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    component Gateway: Item {
        id: gateway

        readonly property var config: root._fragments.gateway

        implicitHeight: Math.max(title.implicitHeight, details.implicitHeight, latency.implicitHeight)

        E.TextTitle {
            id: title
            theme: root._theme
            config: gateway.config.title

            text: 'Gateway'
            anchors.left: parent.left
        }

        E.Text {
            id: details
            theme: root._theme
            config: gateway.config.details

            text: Provider.Network.gatewayDefault.host
            anchors.left: title.right
            anchors.right: latency.left
            anchors.bottom: title.bottom
        }

        E.TextSeverity {
            id: latency
            theme: root._theme
            config: gateway.config.latency

            text:
                Number.isFinite(Provider.Network.gatewayDefault.latency)
                    ? Math.round(Provider.Network.gatewayDefault.latency) + ' ms'
                    : 'ERR'
            value: Provider.Network.gatewayDefault.latency
            anchors.right: parent.right
        }
    }

    Gateway {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    component RateItem: Item {
        id: item

        required property var modelData
        readonly property var config: root._fragments.rate[modelData]

        implicitHeight: Math.max(label.implicitHeight, rate.implicitHeight) + graph.implicitHeight

        E.Text {
            id: label
            theme: root._theme
            config: item.config.label

            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.TextBytes {
            id: rate
            theme: root._theme
            config: item.config.rate

            value: Provider.Network.rate[item.modelData]
            isRate: true
            anchors.right: parent.right
            anchors.bottom: label.bottom
        }

        E.GraphTimeseries {
            id: graph
            theme: root._theme
            config: item.config.graph

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

    }

    Row {
        id: rates

        anchors.left: parent.left
        anchors.right: parent.right
        spacing: root._config.widget.spacing.horizontal

        Repeater {
            model: ['download', 'upload']

            RateItem {
                implicitWidth: (parent.width - rates.spacing) / 2
            }
        }

    }

}
