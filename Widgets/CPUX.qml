pragma ComponentBehavior: Bound

import QtQuick
import qs.Elements as E
import qs.Config as C
import qs.Providers as Provider

Base {
    id: root
    type: 'cpu'
    hierarchy: ['base', type]

    component ConfigFragments: QtObject {

        readonly property QtObject meter: QtObject {

            readonly property C.TextTitle title: C.TextTitle {
                _defaults: root._config.defaults.text_title
            }

            readonly property C.TextTemperature temperature: C.TextTemperature {
                _defaults: root._config.defaults.text_temperature
                text {
                    font {
                        size: 'small'
                    }
                    padding {
                        right: 50
                    }
                }
                thresholds {
                    ignore {
                        value: '<60'
                    }
                    good {
                        value: '<75'
                    }
                    warning {
                        value: '<90'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

            readonly property C.TextPercent percent: C.TextPercent {
                _defaults: root._config.defaults.text_percent
                thresholds {
                    ignore {
                        value: '<5'
                    }
                    good {
                        value: '<70'
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

        readonly property QtObject graph: QtObject {

            readonly property C.GraphTimeseries cpu_usage: C.GraphTimeseries {
                _defaults: root._config.defaults.graph_timeseries
                stroke {
                    color: 'info/primary'
                }
                border {
                    color: 'info/primary'
                }
                fill:  'info/primary%30'
            }

            readonly property C.GraphBars cores_usage: C.GraphBars {
                _defaults: root._config.defaults.graph_bars
                border {
                    color: 'info/primary'
                }
                thresholds {
                    ignore {
                        value: '<10'
                    }
                    good {
                        value: '<70'
                    }
                    warning {
                        value: '<95'
                    }
                    critical {
                        value: 'any'
                    }
                }
            }

        }

        readonly property C.ProcessList process_list: C.ProcessList {
            _defaults: root._config.defaults.process_list
            padding {
                top: 5
            }

            readonly property C.TextPercent percent: C.TextPercent {
                _defaults: root._config.defaults.text_percent
                text {
                    _defaults: root._config.defaults.process_list.value
                }
                thresholds {
                    ignore {
                        value: '<5'
                    }
                    good {
                        value: '<70'
                    }
                    warning {
                        value: '<90'
                    }
                    critical {
                        value: 'any'
                    }
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
        target: Provider.CPU
        function onUpdateCPU(data) {
            cpu_usage.pushValue(data.usage)
        }
        function onUpdateCPUCores(data) {
            cores_usage.pushValues(data.coreUsage)
        }
    }

    Connections {
        target: Provider.Process
        function onUpdateProcessesByCPU(data) {
            processList.pushValues(data)
        }
    }

    component Meter: Item {
        id: meter

        readonly property var config: root._config.fragments.meter

        implicitHeight:
            Math.max(
                title.implicitHeight,
                temperature.implicitHeight,
                percent.implicitHeight,
            ) +
            bar.implicitHeight

        E.TextTitleX {
            id: title
            theme: root._config.theme
            config: meter.config.title

            text: 'CPU'
            anchors.left: parent.left
        }

        E.TextTemperatureX {
            id: temperature
            theme: root._config.theme
            config: meter.config.temperature

            value: Provider.CPU.cpu.temperature
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.TextPercentX {
            id: percent
            theme: root._config.theme
            config: meter.config.percent

            value: Provider.CPU.cpu.usage
            anchors.right: parent.right
            anchors.bottom: title.bottom
        }

        E.BarX {
            id: bar
            theme: root._config.theme
            config: meter.config.bar

            value: Provider.CPU.cpu.usage
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }

    Meter {
        anchors.left: parent.left
        anchors.right: parent.right
    }

    Row {
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: root._config.widget.spacing.horizontal

        E.GraphTimeseriesX {
            id: cpu_usage
            theme: root._config.theme
            config: root._config.fragments.graph.cpu_usage

            width: (parent.width - parent.spacing) / 2
        }

        E.GraphBarsX {
            id: cores_usage
            theme: root._config.theme
            config: root._config.fragments.graph.cores_usage

            width: (parent.width - parent.spacing) / 2
        }
    }

    E.ProcessListX {
        id: processList

        theme: root._config.theme
        config: root._config.fragments.process_list

        anchors.left: parent.left
        anchors.right: parent.right

        E.TextPercentX {
            theme: root._config.theme
            config: root._config.fragments.process_list.percent

            property var modelValue
            // qmllint disable unqualified
            value: modelValue
            // qmllint enable unqualified
        }
    }

}
