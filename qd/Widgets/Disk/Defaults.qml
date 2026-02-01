pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {

    property Widget.Base widget

    mount {

        point {
            _defaults: widget._defaults.text_title
            separator {
                enabled: false
            }
        }

        used {
            _defaults: widget._defaults.text_percent
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

        details {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            color: 'text/secondary'
        }

        free {
            _defaults: widget._defaults.text_bytes
            precision: 3
        }

        total {
            _defaults: widget._defaults.text_bytes
            font {
                size: 'small'
            }
            color:     'text/secondary'
            precision: 3
            prefix:    '  / '
        }

        bar {
            _defaults: widget._defaults.bar
            padding {
                top:    3
                bottom: 2
            }
        }

    }

    rate {

        read {

            label {
                _defaults: widget._defaults.text
                color: 'info/primary'
                text:  'R:'
            }

            rate {
                _defaults: widget._defaults.text_bytes
                font {
                    size: 'small'
                }
                color: 'text/secondary'
            }

            graph {
                _defaults: widget._defaults.graph_timeseries
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

        write {

            label {
                _defaults: widget._defaults.text
                color: 'info/secondary'
                text:  'W:'
            }

            rate {
                _defaults: widget._defaults.text_bytes
                font {
                    size: 'small'
                }
                color: 'text/secondary'
            }

            graph {
                _defaults: widget._defaults.graph_timeseries
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
