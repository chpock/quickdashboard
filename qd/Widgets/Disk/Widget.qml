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

    Connections {
        target: Provider.Disk
        function onUpdateDiskRate(data) {
            rates.children[0].children[2].pushValue(data.readrate)
            rates.children[1].children[2].pushValue(data.writerate)
        }
    }

    component Mount: Column {
        id: mount
        spacing: 0

        readonly property var config: root._fragments.mount
        required property var modelData

        Item {
            implicitHeight: Math.max(point.implicitHeight, used.implicitHeight)
            anchors.left: parent.left
            anchors.right: parent.right

            E.TextTitle {
                id: point
                theme: root._theme
                config: mount.config.point

                text: mount.modelData.mount
                anchors.left: parent.left
                anchors.right: used.left
            }

            E.TextPercent {
                id: used
                theme: root._theme
                config: mount.config.used

                valueCurrent: mount.modelData.used
                valueMax: mount.modelData.size
                anchors.right: parent.right
            }
        }

        Item {
            implicitHeight:
                Math.max(
                    details.implicitHeight,
                    free.implicitHeight,
                    total.implicitHeight
                )
            anchors.left: parent.left
            anchors.right: parent.right

            E.Text {
                id: details
                theme: root._theme
                config: mount.config.details

                text: mount.modelData.fstype !== '' ? '(' + mount.modelData.fstype + ')' : ''
                anchors.left: parent.left
                anchors.bottom: free.bottom
            }

            E.TextBytes {
                id: free
                theme: root._theme
                config: mount.config.free

                value: mount.modelData.avail
                anchors.right: total.left
            }

            E.TextBytes {
                id: total
                theme: root._theme
                config: mount.config.total

                value: mount.modelData.size
                anchors.right: parent.right
                anchors.bottom: free.bottom
            }

        }

        E.Bar {
            id: bar
            theme: root._theme
            config: mount.config.bar

            value: used.calcValue
            anchors.left: parent.left
            anchors.right: parent.right
        }

    }

    Repeater {
        model: Provider.Disk.mountModel

        Mount {
            anchors.left: parent?.left
            anchors.right: parent?.right
        }

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

            value: Provider.Disk.rate[item.modelData]
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
        spacing: root._widget.spacing.horizontal

        Repeater {
            model: ['read', 'write']

            RateItem {
                implicitWidth: (parent.width - rates.spacing) / 2
            }
        }

    }

}
