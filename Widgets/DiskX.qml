pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
import qs.Providers as Provider

Base {
    id: root
    type: 'disk'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property QtObject mount: QtObject {

            readonly property C.TextTitle point: C.TextTitle {
                _defaults: root._config.defaults.text_title
                separator {
                    enabled: false
                }
            }

            readonly property C.TextPercent used: C.TextPercent {
                _defaults: root._config.defaults.text_percent
                thresholds {
                    good {
                        value: '<80'
                    }
                    warning {
                        value: '<95'
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
                color: 'text/secondary'
            }

            readonly property C.TextBytes free: C.TextBytes {
                _defaults: root._config.defaults.text_bytes
                precision: 3
            }

            readonly property C.TextBytes total: C.TextBytes {
                _defaults: root._config.defaults.text_bytes
                text {
                    font {
                        size: 'small'
                    }
                    color: 'text/secondary'
                }
                precision: 3
                prefix:    '  / '
            }

            readonly property C.Bar bar: C.Bar {
                _defaults: root._config.defaults.bar
                padding {
                    top:    3
                    bottom: 2
                }
            }

        }

        readonly property QtObject rate: QtObject {

            readonly property QtObject read: QtObject {

                readonly property C.Text label: C.Text {
                    _defaults: root._config.defaults.text
                    color: 'info/primary'
                    text: 'R:'
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
                        max:    1024 * 10
                        extend: true
                    }
                    border {
                        color: 'info/primary'
                    }
                    padding {
                        top: 2
                    }
                    fill: 'info/primary%30'
                }

            }

            readonly property QtObject write: QtObject {

                readonly property C.Text label: C.Text {
                    _defaults: root._config.defaults.text
                    color: 'info/secondary'
                    text: 'W:'
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
                        max:    1024 * 10
                        extend: true
                    }
                    border {
                        color: 'info/secondary'
                    }
                    padding {
                        top: 2
                    }
                    fill: 'info/secondary%30'
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
        target: Provider.Disk
        function onUpdateDiskRate(data) {
            rates.children[0].children[2].pushValue(data.readrate)
            rates.children[1].children[2].pushValue(data.writerate)
        }
    }

    component Mount: Column {
        id: mount
        spacing: 0

        readonly property var config: root._config.fragments.mount
        required property var modelData

        Item {
            implicitHeight: Math.max(point.implicitHeight, used.implicitHeight)
            anchors.left: parent.left
            anchors.right: parent.right

            E.TextTitleX {
                id: point
                theme: root._config.theme
                config: mount.config.point

                text: mount.modelData.mount
                anchors.left: parent.left
                anchors.right: used.left
            }

            E.TextPercentX {
                id: used
                theme: root._config.theme
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

            E.TextX {
                id: details
                theme: root._config.theme
                config: mount.config.details

                text: mount.modelData.fstype !== '' ? '(' + mount.modelData.fstype + ')' : ''
                anchors.left: parent.left
                anchors.bottom: free.bottom
            }

            E.TextBytesX {
                id: free
                theme: root._config.theme
                config: mount.config.free

                value: mount.modelData.avail
                anchors.right: total.left
            }

            E.TextBytesX {
                id: total
                theme: root._config.theme
                config: mount.config.total

                value: mount.modelData.size
                anchors.right: parent.right
                anchors.bottom: free.bottom
            }

        }

        E.BarX {
            id: bar
            theme: root._config.theme
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
        readonly property var config: root._config.fragments.rate[modelData]

        implicitHeight: Math.max(label.implicitHeight, rate.implicitHeight) + graph.implicitHeight

        E.TextX {
            id: label
            theme: root._config.theme
            config: item.config.label

            anchors.left: parent.left
            anchors.top: parent.top
        }

        E.TextBytesX {
            id: rate
            theme: root._config.theme
            config: item.config.rate

            value: Provider.Disk.rate[item.modelData]
            isRate: true
            anchors.right: parent.right
            anchors.bottom: label.bottom
        }

        E.GraphTimeseriesX {
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
            model: ['read', 'write']

            RateItem {
                implicitWidth: (parent.width - rates.spacing) / 2
            }
        }

    }

}
