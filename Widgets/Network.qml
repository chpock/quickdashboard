pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
import qs.Providers as Provider

Base {
    id: root
    type: 'network'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property QtObject wireless_iface: QtObject {

            readonly property C.TextTitle iface: C.TextTitle {
                _defaults: root._config.defaults.text_title
                text {
                    padding {
                        right: '1ch'
                    }
                }
            }

            readonly property C.Text ssid: C.Text {
                _defaults: root._config.defaults.text
                overflow: 'elide'
                padding {
                    right: '1ch'
                }

                C.Text {
                    style: 'error'
                    color: 'severity/critical'
                }
            }

            readonly property C.TextPercent signal: C.TextPercent {
                _defaults: root._config.defaults.text_percent
                thresholds {
                    good {
                        value: '>=75'
                    }
                    warning {
                        value: '>=20'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

        }

        readonly property QtObject latency: QtObject {

            readonly property C.TextTitle title: C.TextTitle {
                _defaults: root._config.defaults.text_title
                text {
                    padding {
                        right: '1ch'
                    }
                }
            }

            readonly property C.TextSeverity value: C.TextSeverity {
                _defaults: root._config.defaults.text_severity
                thresholds {
                    good {
                        value: '<40'
                    }
                    warning {
                        value: 'any'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

            readonly property C.Text details: C.Text {
                _defaults: root._config.defaults.text
                font {
                    size: 'small'
                }
                padding {
                    top: 4
                }
                color:    'text/secondary'
                overflow: 'elide'
            }

            readonly property QtObject marks: QtObject {

                readonly property C.Spacing spacing: C.Spacing {
                    horizontal: 5
                }

                readonly property C.Padding padding: C.Padding {
                    left:   0
                    right:  0
                    top:    2
                    bottom: 2
                }

                readonly property C.Border border: C.Border {
                    width: 1
                }

                property real width: 8

            }

        }

        readonly property QtObject dns: QtObject {

            readonly property C.TextTitle title: C.TextTitle {
                _defaults: root._config.defaults.text_title
                text {
                    padding {
                        right: '1ch'
                    }
                }
            }

            readonly property C.Text latency: C.Text {
                _defaults: root._config.defaults.text
                font {
                    size: 'small'
                }
                color:    'text/secondary'
                overflow: 'elide'
            }

            readonly property C.TextSeverity status: C.TextSeverity {
                _defaults: root._config.defaults.text_severity
                thresholds {
                    good {
                        value: 'any'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

        }

        readonly property QtObject gateway: QtObject {

            readonly property C.TextTitle title: C.TextTitle {
                _defaults: root._config.defaults.text_title
                text {
                    padding {
                        right: '1ch'
                    }
                }
            }

            readonly property C.Text details: C.Text {
                _defaults: root._config.defaults.text
                font {
                    size: 'small'
                }
                color:    'text/secondary'
                overflow: 'elide'
            }

            readonly property C.TextSeverity latency: C.TextSeverity {
                _defaults: root._config.defaults.text_severity
                thresholds {
                    ignore {
                        value: 'none'
                    }
                    good {
                        value: '<10'
                    }
                    warning {
                        value: 'any'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

        }

        readonly property QtObject rate: QtObject {

            readonly property QtObject download: QtObject {

                readonly property C.Text label: C.Text {
                    _defaults: root._config.defaults.text
                    color: 'info/primary'
                    text: 'D:'
                }

                readonly property C.TextBytes rate: C.TextBytes {
                    _defaults: root._config.defaults.text_bytes
                    text {
                        font {
                            size: 'small'
                        }
                        color: 'text/secondary'
                    }
                }

                readonly property C.GraphTimeseries graph: C.GraphTimeseries {
                    _defaults: root._config.defaults.graph_timeseries
                    stroke {
                        color: 'info/primary'
                    }
                    axisY {
                        max:    1024 * 5
                        extend: true
                    }
                    border {
                        color: 'info/primary'
                    }
                    padding {
                        top: 2
                    }
                    fill:  'info/primary%30'
                }

            }

            readonly property QtObject upload: QtObject {

                readonly property C.Text label: C.Text {
                    _defaults: root._config.defaults.text
                    color: 'info/secondary'
                    text: 'U:'
                }

                readonly property C.TextBytes rate: C.TextBytes {
                    _defaults: root._config.defaults.text_bytes
                    text {
                        font {
                            size: 'small'
                        }
                        color: 'text/secondary'
                    }
                }

                readonly property C.GraphTimeseries graph: C.GraphTimeseries {
                    _defaults: root._config.defaults.graph_timeseries
                    stroke {
                        color: 'info/secondary'
                    }
                    axisY {
                        max:    1024 * 5
                        extend: true
                    }
                    border {
                        color: 'info/secondary'
                    }
                    padding {
                        top: 2
                    }
                    fill:  'info/secondary%30'
                }

            }

        }

    }

    configFragments: ConfigFragments {}

    Component {
        id: configFragmentsComponent
        ConfigFragments {}
    }

    function recreateConfigFragments() {
        configFragments = configFragmentsComponent.createObject(_config)
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
        readonly property var config: root._config.fragments.wireless_iface

        implicitHeight: Math.max(
            iface.implicitHeight,
            ssid.implicitHeight,
            signal.implicitHeight,
        )

        E.TextTitle {
            id: iface
            theme: root._config.theme
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
            theme: root._config.theme
            config: wireless_iface.config.ssid

            text: parent.modelData.ssid
            anchors.left: iface.right
            anchors.right: parent.modelData.isConnected ? signal.right : parent.right
            style: !parent.modelData.isConnected ? 'error' : undefined
        }

        E.TextPercent {
            id: signal
            theme: root._config.theme
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

        readonly property var config: root._config.fragments.latency

        property string hoveredMarkName: ''
        property real hoveredMarkTime: Infinity

        implicitHeight:
            Math.max(title.implicitHeight, value.implicitHeight) +
                details.implicitHeight

        E.TextTitle {
            id: title
            theme: root._config.theme
            config: latency.config.title

            text: 'Latency'
            anchors.left: parent.left
        }

        E.TextSeverity {
            id: value
            theme: root._config.theme
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
            theme: root._config.theme
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
                        latency.config.value.thresholds.getColor(modelData.time, root._config.theme)

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

        readonly property var config: root._config.fragments.dns

        readonly property bool isOk: Number.isFinite(Provider.Network.dnsCheckTime)

        implicitHeight: Math.max(title.implicitHeight, latency.implicitHeight, status.implicitHeight)

        E.TextTitle {
            id: title
            theme: root._config.theme
            config: dns.config.title

            text: 'DNS'
            anchors.left: parent.left
        }

        E.Text {
            id: latency
            theme: root._config.theme
            config: dns.config.latency

            text: dns.isOk ? Provider.Network.dnsCheckTime + ' ms' : ''
            anchors.left: title.right
            anchors.bottom: title.bottom
        }

        E.TextSeverity {
            id: status
            theme: root._config.theme
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

        readonly property var config: root._config.fragments.gateway

        implicitHeight: Math.max(title.implicitHeight, details.implicitHeight, latency.implicitHeight)

        E.TextTitle {
            id: title
            theme: root._config.theme
            config: gateway.config.title

            text: 'Gateway'
            anchors.left: parent.left
        }

        E.Text {
            id: details
            theme: root._config.theme
            config: gateway.config.details

            text: Provider.Network.gatewayDefault.host
            anchors.left: title.right
            anchors.right: latency.left
            anchors.bottom: title.bottom
        }

        E.TextSeverity {
            id: latency
            theme: root._config.theme
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
        readonly property var config: root._config.fragments.rate[modelData]

        implicitHeight: Math.max(label.implicitHeight, rate.implicitHeight) + graph.implicitHeight

        E.Text {
            id: label
            theme: root._config.theme
            config: item.config.label

            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.TextBytes {
            id: rate
            theme: root._config.theme
            config: item.config.rate

            value: Provider.Network.rate[item.modelData]
            isRate: true
            anchors.right: parent.right
            anchors.bottom: label.bottom
        }

        E.GraphTimeseries {
            id: graph
            theme: root._config.theme
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
