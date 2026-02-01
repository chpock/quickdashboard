pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    meter {

        title {
            _defaults: widget._defaults.text_title
            padding {
                right: '2ch'
            }
        }

        free {
            _defaults: widget._defaults.text_bytes
            precision: 3
        }

        total {
            _defaults: widget._defaults.text_bytes
            text {
                font {
                    size: 'small'
                }
                color: 'text/secondary'
            }
            precision: 3
            prefix: '  / '
        }

        percent {
            _defaults: widget._defaults.text_percent
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

        bar {
            _defaults: widget._defaults.bar
            padding {
                top:    3
                bottom: 2
            }
        }

    }

    processes {
        list {
            _defaults: widget._defaults.process_list
            padding {
                top: 2
            }
        }
        value {
            _defaults: widget._defaults.text_bytes
            text {
                _defaults: widget._defaults.process_list.value
            }
            precision: 3
        }
    }

}
