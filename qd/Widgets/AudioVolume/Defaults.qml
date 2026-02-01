pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget

Fragments {
    id: fragments

    property Widget.Base widget

    icon {
        _defaults: widget._defaults.icon
        color: 'text/title'

        styles: ({
            muted: {
                color: 'severity/critical',
            },
            unavailable: {
                color: 'severity/critical',
            },
        })
    }

    indicator {
        _defaults: widget._defaults.icon
        color: 'info/accent'
        padding {
            left: '1ch'
        }
    }

    device {
        _defaults: widget._defaults.text
        font {
            size: 'small'
        }
        padding {
            left:  '1ch'
            right: '1ch'
        }
        overflow: 'elide'
        color: 'text/secondary'

        styles: ({
            unavailable: {
                color: 'severity/critical',
            },
            hover: {
                color: 'text/primary',
            },
        })
    }

    percent {
        _defaults: widget._defaults.text_percent
        thresholds {
            enabled: false
        }
    }

    slider {
        _defaults: widget._defaults.slider
        padding {
            top: 2
        }
    }

}
