pragma ComponentBehavior: Bound

import qs.qd.Widgets as Widget
import qs.qd.Config as C

Fragments {

    property Widget.Base widget

    album_art {

        padding {
            top:    0
            bottom: 0
            left:   0
            right:  10
        }

        size {
            width:  45
            height: 45
        }

        border {
            width: 1
            color: 'text/secondary'
        }

        no_art {
            _defaults: widget._defaults.icon
            font {
                size: 35
            }
            color: 'gray'
        }

    }

    player {

        status {
            _defaults: widget._defaults.text
            overflow:  'elide'

            styles: ({
                unavailable: {
                    color: 'severity/ignore',
                    text:  'No players',
                },
                playing: {
                    color: 'severity/good',
                    text:  'Playing',
                },
                paused: {
                    color: 'info/accent',
                    text:  'Paused',
                },
                stopped: {
                    color: 'severity/critical',
                    text:  'Stopped',
                },
                unknown: {
                    color: 'severity/critical',
                    text:  'Unknown status',
                },
            })
        }

        time {
            _defaults: widget._defaults.text
        }

        control {

            button {
                _defaults: widget._defaults.icon
                hover {
                    enabled: true
                }
                color:  'white'
                filled: true
                weight: 700
            }

            spacing {
                horizontal: 4
            }

            padding {
                top:    1
                bottom: 0
                left:   0
                right:  0
            }

        }

        slider {
            _defaults: widget._defaults.slider
            padding {
                top: 3
            }
        }

        track {
            _defaults: widget._defaults.text
            overflow:  'scroll'
            padding {
                top: 3
            }
        }

        artist {
            _defaults: widget._defaults.text
            font {
                size: 'small'
            }
            padding {
                top: 3
            }
            color:     'text/secondary'
            overflow:  'scroll'
        }

    }

}
