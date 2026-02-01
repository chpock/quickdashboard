pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {

    property Widget.Base widget

    wireless_iface {

        iface {
            _defaults: widget._defaults.text_title
            padding {
                right: '1ch'
            }
        }

        ssid {
            _defaults: widget._defaults.text
            overflow: 'elide'
            padding {
                right: '1ch'
            }

            styles: ({
                error: {
                    color: 'severity/critical',
                },
            })
        }

        signal {
            _defaults: widget._defaults.text_percent
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

    latency {

        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '1ch'
            }
            text: 'Latency'
        }

        value {
            _defaults: widget._defaults.text_severity
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

        details {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            padding {
                top: 4
            }
            color:    'text/secondary'
            overflow: 'elide'
        }

        marks {
            spacing {
                horizontal: 5
            }
            padding {
                left:   0
                right:  0
                top:    2
                bottom: 2
            }
            border {
                width: 1
            }
            width: 8
        }

    }

    dns {

        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '1ch'
            }
            text: 'DNS'
        }

        latency {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            color:    'text/secondary'
            overflow: 'elide'
        }

        status {
            _defaults: widget._defaults.text_severity
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

    gateway {

        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '1ch'
            }
            text: 'Gateway'
        }

        details {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            color:    'text/secondary'
            overflow: 'elide'
        }

        latency {
            _defaults: widget._defaults.text_severity
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

    rate {

        download {

            label {
                _defaults: widget._defaults.text
                color: 'info/primary'
                text: 'D:'
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

        upload {

            label {
                _defaults: widget._defaults.text
                color: 'info/secondary'
                text: 'U:'
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
