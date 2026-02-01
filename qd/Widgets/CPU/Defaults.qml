pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    meter {

        title {
            _defaults: widget._defaults.text_title
        }

        temperature {
            _defaults: widget._defaults.text_temperature
            font {
                size: 'small'
            }
            padding {
                right: 50
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

        percent {
            _defaults: widget._defaults.text_percent
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

        bar {
            _defaults: widget._defaults.bar
            padding {
                top:    3
                bottom: 2
            }
        }

    }

    graph {

        cpu_usage {
            _defaults: widget._defaults.graph_timeseries
            stroke {
                color: 'info/primary'
            }
            border {
                color: 'info/primary'
            }
            fill:  'info/primary%30'
        }

        cores_usage {
            _defaults: widget._defaults.graph_bars
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

    processes {

        list {
            _defaults: widget._defaults.process_list
            padding {
                top: 5
            }
        }

        value {
            _defaults: widget._defaults.text_percent
            alignment {
                horizontal: 'right'
            }
            font {
                size: 'small'
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
