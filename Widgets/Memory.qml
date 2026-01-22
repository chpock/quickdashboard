pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
import qs.Providers as Provider

Base {
    id: root
    type: 'memory'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property QtObject meter: QtObject {

            readonly property C.TextTitle title: C.TextTitle {
                _defaults: root._config.defaults.text_title
                text {
                    padding {
                        right: '2ch'
                    }
                }
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
                prefix: '  / '
            }

            readonly property C.TextPercent percent: C.TextPercent {
                _defaults: root._config.defaults.text_percent
                thresholds {
                    good {
                        value: '<60'
                    }
                    warning {
                        value: '<90'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

            readonly property C.Bar bar: C.Bar {
                _defaults: root._config.defaults.bar
                padding {
                    top:    3
                    bottom: 2
                }
            }

        }

        readonly property C.ProcessList process_list: C.ProcessList {
            _defaults: root._config.defaults.process_list
            padding {
                top: 2
            }

            readonly property C.TextBytes bytes: C.TextBytes {
                _defaults: root._config.defaults.text_bytes
                text {
                    _defaults: root._config.defaults.process_list.value
                }
                precision: 3
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
        target: Provider.Process
        function onUpdateProcessesByRAM(data) {
            processList.pushValues(data)
        }
    }

    readonly property int titleWidth: Math.max(meterRAM.titleWidth, meterSwap.titleWidth)

    component Meter: Item {
        id: meter

        readonly property alias titleWidth: titleObj.implicitWidth
        readonly property var config: root._config.fragments.meter

        property alias title: titleObj.text
        property alias free: freeObj.value
        property alias total: totalObj.value

        implicitHeight:
            Math.max(
                titleObj.implicitHeight,
                freeObj.implicitHeight,
                totalObj.implicitHeight,
                percentObj.implicitHeight
            ) +
            barObj.implicitHeight

        E.TextTitle {
            id: titleObj
            theme: root._config.theme
            config: meter.config.title

            anchors.left: parent.left
            width: root.titleWidth
        }

        // qmllint disable required
        E.TextBytes {
            id: freeObj
            theme: root._config.theme
            config: meter.config.free

            anchors.left: titleObj.right
            anchors.bottom: titleObj.bottom
        }
        // qmllint enable required

        // qmllint disable required
        E.TextBytes {
            id: totalObj
            theme: root._config.theme
            config: meter.config.total

            anchors.left: freeObj.right
            anchors.bottom: titleObj.bottom
        }
        // qmllint enable required

        E.TextPercent {
            id: percentObj
            theme: root._config.theme
            config: meter.config.percent

            valueCurrent: meter.total - meter.free
            valueMax: meter.total
            anchors.right: parent.right
        }

        E.Bar {
            id: barObj
            theme: root._config.theme
            config: meter.config.bar

            value: percentObj.calcValue
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Meter {
        id: meterRAM

        anchors.left: parent.left
        anchors.right: parent.right

        title: 'RAM'
        free:  Provider.Memory.ram.available
        total: Provider.Memory.ram.total
    }

    Meter {
        id: meterSwap

        anchors.left: parent.left
        anchors.right: parent.right

        title: 'Swap'
        free:  Provider.Memory.swap.free
        total: Provider.Memory.swap.total
    }

    E.ProcessList {
        id: processList
        theme: root._config.theme
        config: root._config.fragments.process_list

        anchors.left: parent.left
        anchors.right: parent.right

        E.TextBytes {
            theme: root._config.theme
            config: root._config.fragments.process_list.bytes

            property var modelValue
            // qmllint disable unqualified
            value: modelValue
            // qmllint enable unqualified
        }
    }

}
